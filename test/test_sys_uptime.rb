#####################################################################
# test_sys_uptime.rb
#
# Test suite for sys-uptime. This should generally be run via the
# 'rake test' task, since it handles the pre-setup code for you.
#####################################################################
require 'rubygems'
gem 'test-unit'

require 'sys/uptime'
require 'test/unit'
include Sys

class TC_Sys_Uptime < Test::Unit::TestCase
  test "version is set to expected value" do
    assert_equal('0.6.0', Uptime::VERSION)
  end

  test "seconds method basic functionality" do
    assert_respond_to(Uptime, :seconds)
    assert_nothing_raised{ Uptime.seconds }
  end

  test "seconds method returns a plausible value" do
    assert_kind_of(Integer, Uptime.seconds)
    assert_true(Uptime.seconds > 300)
  end

  test "minutes method basic functionality" do
    assert_respond_to(Uptime, :minutes)
    assert_nothing_raised{ Uptime.minutes }
  end

  test "minutes method returns a plausible value" do
    assert_kind_of(Integer, Uptime.minutes)
    assert_true(Uptime.minutes > 5)
  end

  test "hours method basic functionality" do
    assert_respond_to(Uptime, :hours)
    assert_nothing_raised{ Uptime.hours }
  end

  test "hours method returns a plausible value" do
    assert_kind_of(Integer, Uptime.hours)
    assert_true(Uptime.hours > 0)
  end

  test "days method basic functionality" do
    assert_respond_to(Uptime,:days)
    assert_nothing_raised{ Uptime.days }
  end

  test "days method returns a plausible value" do
    assert_kind_of(Fixnum, Uptime.days)
    assert_true(Uptime.days >= 0)
  end

  test "uptime method basic functionality" do
    assert_respond_to(Uptime,:uptime)
    assert_nothing_raised{ Uptime.uptime }
  end

  test "uptime method returns a non-empty string" do
    assert_kind_of(String, Uptime.uptime)
    assert_false(Uptime.uptime.empty?)
  end

  test "uptime method does not accept any arguments" do
    assert_raise(ArgumentError){ Uptime.uptime(1) }
  end

  test "dhms method basic functionality" do
    assert_respond_to(Uptime,:dhms)
    assert_nothing_raised{ Uptime.dhms }
    assert_kind_of(Array, Uptime.dhms)
  end

  test "dhms method returns an array of four elements" do
    assert_false(Uptime.dhms.empty?)
    assert_equal(4, Uptime.dhms.length)
  end

  test "boot_time method basic functionality" do
    assert_respond_to(Uptime,:boot_time)
    assert_nothing_raised{ Uptime.boot_time }
  end

  test "boot_time method returns a Time object" do
    assert_kind_of(Time, Uptime.boot_time)
  end

  test "Uptime class cannot be instantiated" do
    assert_kind_of(StandardError, Uptime::Error.new)
  end
end
