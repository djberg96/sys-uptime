#####################################################################
# tc_uptime.rb
#
# Test suite for sys-uptime. This should generally be run via the
# 'rake test' task, since it handles the pre-setup code for you.
#####################################################################
require 'sys/uptime'
require 'test/unit'
include Sys

class TC_Uptime < Test::Unit::TestCase
   def test_version
      assert_equal('0.6.0', Uptime::VERSION)
   end

   def test_seconds
      assert_respond_to(Uptime, :seconds)
      assert_nothing_raised{ Uptime.seconds }
      assert_kind_of(Fixnum, Uptime.seconds)
      assert_equal(true, Uptime.seconds > 0)
   end

   def test_minutes
      assert_respond_to(Uptime, :minutes)
      assert_nothing_raised{ Uptime.minutes }
      assert_kind_of(Fixnum, Uptime.minutes)
   end

   def test_hours
      assert_respond_to(Uptime, :hours)
      assert_nothing_raised{ Uptime.hours }
      assert_kind_of(Fixnum, Uptime.hours)
   end

   def test_days
      assert_respond_to(Uptime,:days)
      assert_nothing_raised{ Uptime.days }
      assert_kind_of(Fixnum, Uptime.days)
   end 

   def test_uptime
      assert_respond_to(Uptime,:uptime)
      assert_nothing_raised{ Uptime.uptime }
      assert_kind_of(String, Uptime.uptime)
      assert_equal(false, Uptime.uptime.empty?)
   end
   
   def test_dhms
      assert_respond_to(Uptime,:dhms)
      assert_nothing_raised{ Uptime.dhms }
      assert_kind_of(Array, Uptime.dhms)
      assert_equal(false, Uptime.dhms.empty?)
      assert_equal(4, Uptime.dhms.length)
   end
   
   def test_boot_time
      assert_respond_to(Uptime,:boot_time)
      assert_nothing_raised{ Uptime.boot_time }
      assert_kind_of(Time, Uptime.boot_time)
   end

   def test_uptime_error
      assert_kind_of(StandardError, Uptime::Error.new)
   end
end
