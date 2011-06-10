module AxisAPI
  class AxisFTPError < StandardError; end
  class AxisAPIError < StandardError; end
  class AxisConfigError < StandardError; end
end

Dir.glob(File.join(File.dirname(__FILE__), 'axis_api', '*.rb')).each{ |f| require f }