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
    expect(Sys::Uptime::VERSION).to eql('0.7.3')
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

  example "uptime accepts a host name on Windows", :if => File::ALT_SEPARATOR do
    expect{ Sys::Uptime.uptime(Socket.gethostname) }.not_to raise_error
  end

  example "dhms method basic functionality" do
    expect(Sys::Uptime).to respond_to(:dhms)
    expect{ Sys::Uptime.dhms }.not_to raise_error
    expect(Sys::Uptime.dhms).to be_kind_of(Array)
  end

  example "dhms method returns an array of four elements" do
    expect(Sys::Uptime.dhms).not_to be_empty
    expect(Sys::Uptime.dhms.length).to eql(4)
  end

  example "boot_time method basic functionality" do
    expect(Sys::Uptime).to respond_to(:boot_time)
    expect{ Sys::Uptime.boot_time }.not_to raise_error
  end

  example "boot_time method returns a Time object" do
    expect(Sys::Uptime.boot_time).to be_kind_of(Time)
  end

  example "Uptime class cannot be instantiated" do
    expect{ Sys::Uptime.new }.to raise_error(StandardError)
  end

  example "Ensure that ffi functions are private" do
    methods = Sys::Uptime.methods(false).map{ |e| e.to_s }
    expect(methods).not_to include('time', 'times')
  end
end
