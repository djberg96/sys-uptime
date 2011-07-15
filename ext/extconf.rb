##########################################################################
# extconf.rb
#
# Configuration & build script for sys-uptime. Generally speaking you
# should build sys-uptime with the 'rake build' task instead of running
# this script manually.
##########################################################################
require 'mkmf'
require 'fileutils'

if RUBY_PLATFORM =~ /windows|win32|cygwin|mingw|dos|linux/i
  STDERR.puts "Do not compile on this platform. Run 'rake gem:install' instead."
  exit
end

dir_config('uptime')

have_header('sys/loadavg.h')

if have_func('sysctl')
  have_header('sys/param.h')
  have_header('sys/time.h')
  have_header('sys/types.h')
else
  have_header('utmpx.h')
end

create_makefile('sys/uptime', 'sys')
