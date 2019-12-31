if File::ALT_SEPARATOR
  require_relative 'windows/sys/uptime'
else
  require_relative 'unix/sys/uptime'
end

module Sys
  class Uptime
    # The version of the sys-uptime library
    VERSION = '0.7.3'.freeze
  end
end
