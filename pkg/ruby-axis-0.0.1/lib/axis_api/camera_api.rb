require 'ping'
require 'timeout'
require 'net/http'

# requires -l 408 according to manual 
# ping -l 408 -t 192.168.0.125
module AxisAPI
  module CameraAPI
  
    ONLINE       = 1
    STREAMING    = 2
    REFRESHING   = 4
    DOWNLOADING  = 8
    UPLOADING    = 16
    UNDEFINED    = 2048
    
    
    @@axis_config_file = "config/axis.yml"
    @axis_config_file = "config/axis.yml"
    @@ftp_timeout = 30
    
    def self.included(base)
      h = YAML.load_file(File.join(Rails.root, @axis_config_file))
      h.keys.each do |cmd|
        path  = h[cmd][:path]
        query = h[cmd][:query]
        base.class_eval <<-"end;"
          cattr_accessor :base_path, :protocol, :auth_name
          cattr_accessor :axis_config_file, :remote_storage_dir, :local_storage_dir
          def axis_config_file
            @axis_config_file ||= @@axis_config_file
          end
          
          def #{cmd.to_s}(*additional_params)
            vapix_request("#{path.to_s}?#{query.to_s}", *additional_params) 
          end
        end;
      end
      base.extend ClassMethods
    end
    
    module ClassMethods
      def statuses
        {
          ONLINE       => :online, 
          STREAMING    => :streaming,
          REFRESHING   => :refreshing,
          DOWNLOADING  => :downloading,
          UPLOADING    => :uploading,
          UNDEFINED    => :undefined
        }
      end
      
      
      def vapix_hash(filename="axis.yml")
        YAML.load_file(File.join(Rails.root, 'config', filename))
      end
      
    end
    
    def ping
      Ping.pingecho address, 5, 80
    end
    
    
    # Low level AXIS methods
    
    # telnet cl request
    def axis_commands(instance, *commands)
      instance.axis_commands(commands)
    end
      
    
    
    # VAPIX request
    def vapix_request(predicate, *additional_params)
      uri = URI.parse "http://" + "#{address}/#{self.class.base_path}/#{URI.encode(predicate)}".gsub(/\/+/, '/')
      logger.debug "vapix_request received for URI:#{uri}"
      execute_remote(uri, *additional_params)
      # what do to with a specific command is in the iomplementation, for example
      # when a networked Axis camera gets execute_remote with a url,
      # it fetched the results iof the http and perfomras some other action
  #  rescue
  #    raise NoMethodError.new "No method matching #{predicate}"
    end
    
    
    def vapix_lookup(key)
      vapix_hash[key]
    end  
    
    
    def vapix_reverse_lookup(value)
      vapix_hash.each_pair do |k,v|
        if v[:path] == value
          return k 
        end
      end
      raise "didn't find a key for value #{value}"
    end
    
    
    def vapix_hash
      YAML.load_file(File.join(Rails.root, axis_config_file))
    end
    
    
    
    # responses to VAPIX requests come in NAME=VALUE by default
    # like root.Event.E0.Actions
    # or root.Coves.C0.Master
    # TODO - bct - use parhandclient on a socket to make our own
    def parse_vapix_response(raw)
      if raw =~ /Error: Error/
        return {}
      end
      response = nested_hash
      raw_responses = raw.split(/\n/)
      raw_responses.each do |raw_response|
        raw_key_string, raw_value = raw_response.split('=')
        raw_keys = raw_key_string.split('.')
        raw_keys.shift # get rid of root.
        last_key      = nil
        semilast_hash = nil
        last_hash     = response
        raw_keys.length.times do |level|
          last_key      = raw_keys[level]
          semilast_hash = last_hash
          last_hash     = last_hash[last_key]
        end
        semilast_hash[raw_keys.last] = raw_value
      end
      return response
    end 
    
    
    def nested_hash
      Hash.new{ |hash, key| hash[key] = nested_hash }
    end
    
    
    
    # admin templates
    
    def admin_templates
      dir = File.join(File.dirname(__FILE__), 'template')
      Dir.glob(File.join(dir, "*_par.conf.erb"))
    end
    
    
    def admin_template_process_all
      tmpfiles  = []
      admin_templates.each do |template|
        camera = self
        b = binding
        erb = ERB.new(File.read(template), 0, '', '@_erbout')
        erb.result(b)
        File.open(File.join(File.dirname(__FILE__), '../..', 'tmp', File.basename(template)), 'w') do |tmpfile|
          tmpfile   << @_erbout
          tmpfiles  << File.expand_path(tmpfile.path)
        end
        # @_erbout = nil # shouldn't be necessary with binding
      end
      return tmpfiles
    end
  
    
    
    
    
    # TODO - bct - add timeout or something, it hangs on some stuff or no ncameras that
    # happen to answer
    # Access to the pre-configured ftp instance
    def ftp
      if @_ftp
        if @_ftp.closed?
          @_ftp = Net::FTP.new(address)
          @_ftp.login(self.auth_name, admin_password)
        else
          @_ftp
        end
      else
        @_ftp = Net::FTP.new(address)
        @_ftp.login(self.auth_name, admin_password)
      end
      @_ftp
    end
    
    
    
    
    
    # FTP-based methods, per file
    
    def file_list(path='.', include_hidden=false)
      if include_hidden
       Timeout::timeout(@@ftp_timeout) { ftp.nlst(File.join(self.remote_storage_dir, path)) }
      else
        Timeout::timeout(@@ftp_timeout) { ftp.nlst(File.join(self.remote_storage_dir, path)).reject{ |f| f=~ /^\./ } }
      end
    rescue Net::FTPPermError => nftpe
      return path =~ /\.#{Recording.mime_ext}$/ ? nil : []
    end
    
    
    def file_exists?(remote_filename)
      return false if remote_filename.blank?
      remote  = File.join(self.remote_storage_dir, remote_filename)
      Timeout::timeout(@@ftp_timeout) { ftp.ls(remote) }
      return true
    rescue Net::FTPPermError => nftpe
      if nftpe.message =~ /not a directory/i
        return true
      else
        return false
      end
    end
    
    
    def file_get(remote_filename, local_filename=remote_filename)
      local   = File.join(self.local_storage_dir, File.basename(local_filename)) 
      remote  = File.join(self.remote_storage_dir, remote_filename)
      Timeout::timeout(@@ftp_timeout) { ftp.getbinaryfile(remote, local) }
      return local
    end
    
    
    def file_rm(remote_filename)
      Timeout::timeout(@@ftp_timeout) { ftp.delete(File.join(self.remote_storage_dir, remote_filename)) }
    rescue Net::FTPPermError => nftpe
      nil
    end


    # BCT - has to be done this silly way because Axis ftp "size" command is broken
    def file_size(remote_filename)
      rpath = File.join(self.remote_storage_dir, remote_filename)
      rfile = File.basename(rpath)
      rdir  = File.dirname(rpath)

      Timeout::timeout(@@ftp_timeout) { entries = ftp.ls(rdir) }
      correct = entries.detect{ |entry| entry =~ /#{rfile}/ }

      Integer(correct.split[4])

    rescue Net::FTPPermError => nftpe
      nil
    end
    
    
    def file_close
      Timeout::timeout(@@ftp_timeout) do
        unless @_ftp.nil?
          @_ftp.close unless @_ftp.closed?
        end
      end
    rescue
      nil
    ensure
      @_ftp = nil
    end
    
    
  end
  
end