# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-axis}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bryan Taylor"]
  s.date = %q{2011-06-02}
  s.description = %q{A gem that provides a ruby API to Axis cameras}
  s.email = %q{btaylor39 @nospam@ csc.com}
  s.extra_rdoc_files = ["lib/axis_api.rb", "lib/axis_api/camera_api.rb", "lib/axis_api/coves_mkv.conf.erb", "lib/axis_api/network_api.rb", "lib/axis_api/pipe_api.rb", "lib/axis_api/recording_api.rb", "lib/axis_api/template/coves_event_grp.conf", "lib/axis_api/template/coves_event_par.conf.erb", "lib/axis_api/template/coves_http_config_grp.conf", "lib/axis_api/template/coves_http_config_par.conf.erb", "lib/axis_api/template/coves_httpaction_grp.conf", "lib/axis_api/template/coves_httpaction_par.conf.erb", "lib/axis_api/template/coves_motion_grp.conf", "lib/axis_api/template/coves_motion_par.conf.erb", "lib/axis_api/template/coves_recordaction_grp.conf", "lib/axis_api/template/coves_recordaction_par.conf.erb", "lib/axis_api/template/coves_settings_grp.conf", "lib/axis_api/template/coves_settings_par.conf.erb", "lib/axis_api/template/coves_streamprofile_grp.conf", "lib/axis_api/template/coves_streamprofile_par.conf.erb", "lib/axis_api/template/orig/button_grp.conf", "lib/axis_api/template/orig/button_par.conf", "lib/axis_api/template/orig/customexposurewindow_grp.conf", "lib/axis_api/template/orig/customexposurewindow_par.conf", "lib/axis_api/template/orig/daynightaction_grp.conf", "lib/axis_api/template/orig/daynightaction_par.conf", "lib/axis_api/template/orig/ftp_config_grp.conf", "lib/axis_api/template/orig/ftp_config_par.conf", "lib/axis_api/template/orig/ftpaction_grp.conf", "lib/axis_api/template/orig/ftpaction_par.conf", "lib/axis_api/template/orig/guardtour_grp.conf", "lib/axis_api/template/orig/guardtour_par.conf", "lib/axis_api/template/orig/guardtouraction_grp.conf", "lib/axis_api/template/orig/guardtouraction_par.conf", "lib/axis_api/template/orig/hwaction_grp.conf", "lib/axis_api/template/orig/hwaction_par.conf", "lib/axis_api/template/orig/position_grp.conf", "lib/axis_api/template/orig/position_par.conf", "lib/axis_api/template/orig/ptzaction_grp.conf", "lib/axis_api/template/orig/ptzaction_par.conf", "lib/axis_api/template/orig/smtpaction_grp.conf", "lib/axis_api/template/orig/smtpaction_par.conf", "lib/axis_api/template/orig/tcp_config_grp.conf", "lib/axis_api/template/orig/tcp_config_par.conf", "lib/axis_api/template/orig/tcpaction_grp.conf", "lib/axis_api/template/orig/tcpaction_par.conf", "lib/axis_api/template/orig/tour_grp.conf", "lib/axis_api/template/orig/tour_par.conf"]
  s.files = ["Manifest", "Rakefile", "config/axis.yml", "lib/axis_api.rb", "lib/axis_api/camera_api.rb", "lib/axis_api/coves_mkv.conf.erb", "lib/axis_api/network_api.rb", "lib/axis_api/pipe_api.rb", "lib/axis_api/recording_api.rb", "lib/axis_api/template/coves_event_grp.conf", "lib/axis_api/template/coves_event_par.conf.erb", "lib/axis_api/template/coves_http_config_grp.conf", "lib/axis_api/template/coves_http_config_par.conf.erb", "lib/axis_api/template/coves_httpaction_grp.conf", "lib/axis_api/template/coves_httpaction_par.conf.erb", "lib/axis_api/template/coves_motion_grp.conf", "lib/axis_api/template/coves_motion_par.conf.erb", "lib/axis_api/template/coves_recordaction_grp.conf", "lib/axis_api/template/coves_recordaction_par.conf.erb", "lib/axis_api/template/coves_settings_grp.conf", "lib/axis_api/template/coves_settings_par.conf.erb", "lib/axis_api/template/coves_streamprofile_grp.conf", "lib/axis_api/template/coves_streamprofile_par.conf.erb", "lib/axis_api/template/orig/button_grp.conf", "lib/axis_api/template/orig/button_par.conf", "lib/axis_api/template/orig/customexposurewindow_grp.conf", "lib/axis_api/template/orig/customexposurewindow_par.conf", "lib/axis_api/template/orig/daynightaction_grp.conf", "lib/axis_api/template/orig/daynightaction_par.conf", "lib/axis_api/template/orig/ftp_config_grp.conf", "lib/axis_api/template/orig/ftp_config_par.conf", "lib/axis_api/template/orig/ftpaction_grp.conf", "lib/axis_api/template/orig/ftpaction_par.conf", "lib/axis_api/template/orig/guardtour_grp.conf", "lib/axis_api/template/orig/guardtour_par.conf", "lib/axis_api/template/orig/guardtouraction_grp.conf", "lib/axis_api/template/orig/guardtouraction_par.conf", "lib/axis_api/template/orig/hwaction_grp.conf", "lib/axis_api/template/orig/hwaction_par.conf", "lib/axis_api/template/orig/position_grp.conf", "lib/axis_api/template/orig/position_par.conf", "lib/axis_api/template/orig/ptzaction_grp.conf", "lib/axis_api/template/orig/ptzaction_par.conf", "lib/axis_api/template/orig/smtpaction_grp.conf", "lib/axis_api/template/orig/smtpaction_par.conf", "lib/axis_api/template/orig/tcp_config_grp.conf", "lib/axis_api/template/orig/tcp_config_par.conf", "lib/axis_api/template/orig/tcpaction_grp.conf", "lib/axis_api/template/orig/tcpaction_par.conf", "lib/axis_api/template/orig/tour_grp.conf", "lib/axis_api/template/orig/tour_par.conf", "ruby-axis.gemspec"]
  s.homepage = %q{http://github.com/rubyisbeautiful/ruby-axis}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ruby-axis"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ruby-axis}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{features: uses VAPIX, telnet, scripting}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
