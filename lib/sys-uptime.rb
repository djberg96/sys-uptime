if File::ALT_SEPARATOR
  require_relative 'windows/sys/uptime'
else
  require_relative 'unix/sys/uptime'
end
