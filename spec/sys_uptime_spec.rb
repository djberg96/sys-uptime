#####################################################################
# sys_uptime_spec.rb
#
# Test suite for sys-uptime. This should generally be run via the
# 'rake test' task, since it handles the pre-setup code for you.
#####################################################################
require 'sys/uptime'
require 'test-unit'
require 'socket'

describe Sys::Uptime do
  example "version is set to expected value" do
    expect(Sys::Uptime::VERSION).to eql('0.7.2')
    expect(Sys::Uptime::VERSION.frozen?).to be(true)
  end

  example "seconds method basic functionality" do
    expect(Sys::Uptime).to respond_to(:seconds)
    expect{ Sys::Uptime.seconds }.not_to raise_error
  end

  example "seconds method returns a plausible value" do
    expect(Sys::Uptime.seconds).to be_kind_of(Integer)
    expect(Sys::Uptime.seconds).to be > 300
  end

  example "minutes method basic functionality" do
    expect(Sys::Uptime).to respond_to(:minutes)
    expect{ Sys::Uptime.minutes }.not_to raise_error
  end

  example "minutes method returns a plausible value" do
    expect(Sys::Uptime.minutes).to be_kind_of(Integer)
    expect(Sys::Uptime.minutes).to be > 5
  end

  example "hours method basic functionality" do
    expect(Sys::Uptime).to respond_to(:hours)
    expect{ Sys::Uptime.hours }.not_to raise_error
  end

  example "hours method returns a plausible value" do
    expect(Sys::Uptime.hours).to be_kind_of(Integer)
    expect(Sys::Uptime.hours).to be > 0
  end

  example "days method basic functionality" do
    expect(Sys::Uptime).to respond_to(:days)
    expect{ Sys::Uptime.days }.not_to raise_error
  end

  example "days method returns a plausible value" do
    expect(Sys::Uptime.days).to be_kind_of(Integer)
    expect(Sys::Uptime.days).to be >= 0
  end

  example "uptime method basic functionality" do
    expect(Sys::Uptime).to respond_to(:uptime)
    expect{ Sys::Uptime.uptime }.not_to raise_error
  end

  example "uptime method returns a non-empty string" do
    expect(Sys::Uptime.uptime).to be_kind_of(String)
    expect(Sys::Uptime.uptime.empty?).to be(false)
  end

  example "uptime method does not accept any arguments", :unless => File::ALT_SEPARATOR do
    expect{ Sys::Uptime.uptime(1) }.to raise_error(ArgumentError)
  end

=begin
  example "uptime accepts a host name on Windows" do
    omit_unless(File::ALT_SEPARATOR, "MS Windows only")
    assert_nothing_raised{ Uptime.uptime(Socket.gethostname) }
  end

  example "dhms method basic functionality" do
    assert_respond_to(Uptime, :dhms)
    assert_nothing_raised{ Uptime.dhms }
    assert_kind_of(Array, Uptime.dhms)
  end

  example "dhms method returns an array of four elements" do
    assert_false(Uptime.dhms.empty?)
    assert_equal(4, Uptime.dhms.length)
  end

  example "boot_time method basic functionality" do
    assert_respond_to(Uptime, :boot_time)
    assert_nothing_raised{ Uptime.boot_time }
  end

  example "boot_time method returns a Time object" do
    assert_kind_of(Time, Uptime.boot_time)
  end

  example "Uptime class cannot be instantiated" do
    assert_kind_of(StandardError, Uptime::Error.new)
  end

  example "Ensure that ffi functions are private" do
    methods = Uptime.methods(false).map{ |e| e.to_s }
    assert_false(methods.include?('time'))
    assert_false(methods.include?('times'))
  end
=end
end
