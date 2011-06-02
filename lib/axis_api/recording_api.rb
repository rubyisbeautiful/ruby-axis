require 'ping'

module AxisAPI
  module RecordingAPI
    REMOTE    = 1
    LOCAL     = 2
    QUEUED    = 4
    SYNCED    = 512
    ARCHIVED  = 1024
    UNDEFINED = 2048  
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      def statuses
        {
          REMOTE    => :remote, 
          LOCAL     => :local,
          QUEUED    => :queued,
          SYNCED    => :synced,
          ARCHIVED  => :archived,
          UNDEFINED => :undefined
        }
      end
      
      
      def mime_type(which='video')
        unless which.blank?
          possible = Mime::Type.lookup(which)
          return possible unless possible.symbol.blank?
        end
        case
        when %w( image graphic picture snapshot still stillframe ).include?(which.downcase)
          Mime::Type.lookup('image/jpg')
        else
          Mime::Type.lookup('video/matroska')
        end
      end
      
      
      def mime_ext(which='video')
        self.mime_type(which).symbol.to_s
      end
      
      
      def extract_date_from_filename(path)
        # example 20100728_135106_9876_00408ca59a89.mkv
        # => Wed, 28 Jul 2010 13:51:06 +0000
        # DateTime::civil(y=-4712, m=1, d=1, h=0, min=0, s=0, of=0, sg=ITALY)
        r = %r/(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})/
        match = r.match(path).captures
        logger.debug "extract_date_from_filename in: #{path}"
        logger.debug "extract_date_from_filename out: #{match}"
        DateTime.civil(match[0].to_i, match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i, match[5].to_i)
      rescue
        nil
      end
      
      
      def extract_date_from_path(path)
        # example 20100728/13
        # example 20100728/13/20100728_135106_9876_00408ca59a89.mkv
        # => Wed, 28 Jul 2010 13:51:00 +0000
        # DateTime::civil(y=-4712, m=1, d=1, h=0, min=0, s=0, of=0, sg=ITALY)
        r = %r/(\d{4})(\d{2})(\d{2})\/(\d{2})/
        match = r.match(path).captures
        logger.debug "extract_date_from_filename in: #{path}"
        logger.debug "extract_date_from_filename out: #{match}"
        DateTime.civil(match[0].to_i, match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i)
      rescue
        nil
      end
      
      
      def compile_partial_filename_from_date(date)
        sprintf("%s_%02d%02d", 
          date.to_s(:axis_date), 
          date.hour, 
          date.min)
      end
      
      
      def compile_path_from_date(date, first_segment_only=false)
        # example Time.now becomes
        # 20100921/14/
        if first_segment_only
          date.to_formatted_s(:axis_date)
        else
          date.to_formatted_s(:axis_path)  
        end
      end
      
      
      def compile_path_from_filename(path)
        # example 20100728_135106_9876_00408ca59a89.mkv becomes
        # 20100728/13/20100728_135106_9876_00408ca59a89.mkv
        r = %r/(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})/
        match = r.match(path).captures
        File.join("#{match[0]}#{match[1]}#{match[2]}", match[3], path) 
      rescue
        nil
      end
      
      
      def status_filter_names
        [
          'all', 
          'local only', 
          'remote only', 
          'remote AND local',
          'remote OR local',
          'remote AND NOT queued'
        ]
      end
      
      
      def status_filter_conditions
        {
          'all'                   => '1=1',
          'remote only'           => self.remote_only_condition,
          'local only'            => self.local_only_condition,
          'remote AND local'      => self.remote_and_local_condition,
          'remote OR local'       => self.remote_or_local_condition,
          'remote AND NOT queued' => self.remote_and_not_queued_condition,
        }
      end
      
      
      def remote_only_condition
        result = []
        result.push "status = %d" % ( Recording::REMOTE )
        result.push "status = %d" % ( Recording::REMOTE | Recording::SYNCED )
        result.push "status = %d" % ( Recording::REMOTE | Recording::QUEUED )
        result.push "status = %d" % ( Recording::REMOTE | Recording::SYNCED | Recording::QUEUED )
        return result.join " OR "
      end
      
      
      def local_only_condition
        result = []
        result.push "status = %d" % ( Recording::LOCAL )
        result.push "status = %d" % ( Recording::LOCAL | Recording::SYNCED )
        result.push "status = %d" % ( Recording::LOCAL | Recording::QUEUED )
        result.push "status = %d" % ( Recording::LOCAL | Recording::SYNCED | Recording::QUEUED )
        return result.join " OR "
      end  
      
      
      def remote_and_local_condition
        result = []
        result.push "status = %d" % ( Recording::LOCAL | Recording::REMOTE )
        result.push "status = %d" % ( Recording::LOCAL | Recording::REMOTE | Recording::SYNCED )
        result.push "status = %d" % ( Recording::LOCAL | Recording::REMOTE | Recording::QUEUED )
        result.push "status = %d" % ( Recording::LOCAL | Recording::REMOTE | Recording::SYNCED | Recording::QUEUED )
        return result.join " OR "
      end
      
      
      def remote_or_local_condition
        return [self.remote_only_condition, self.local_only_condition].join " OR "
      end
      
      
      def remote_and_not_queued_condition
        result = []
        result.push "status = %d" % ( Recording::REMOTE )
        result.push "status = %d" % ( Recording::REMOTE | Recording::SYNCED )
        return result.join " OR "
      end
      
    end
    
    
  end
  
end