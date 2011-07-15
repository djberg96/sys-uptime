###########################################################
# uptime_test.rb
#
# A generic test script for general futzing. You can run
# this script via the 'rake example' task.
###########################################################
require 'sys/uptime'
include Sys

print "\nGENERIC TEST SCRIPT FOR SYS-UPTIME\n\n"
puts 'VERSION: ' + Uptime::VERSION

puts "Days: " + Uptime.days.to_s
puts "Hours: " + Uptime.hours.to_s
puts "Minutes: " + Uptime.minutes.to_s
puts "Seconds: " + Uptime.seconds.to_s
puts "Uptime: " + Uptime.uptime
puts "DHMS: " + Uptime.dhms.join(', ')
puts "Boot Time: " + Uptime.boot_time.to_s

print "\nTest successful\n"
