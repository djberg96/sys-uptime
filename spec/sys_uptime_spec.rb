#####################################################################
# sys_uptime_spec.rb
#
# Test suite for sys-uptime. This should generally be run via the
# 'rake test' task, since it handles the pre-setup code for you.
#####################################################################
require 'sys/uptime'
require 'rspec'
require 'socket'

describe Sys::Uptime do
  let(:plausible_seconds) { ENV['CI'] ? 30 : 120 }

  example 'version is set to expected value' do
    expect(Sys::Uptime::VERSION).to eql('0.7.5')
    expect(Sys::Uptime::VERSION.frozen?).to be(true)
  end

  example 'constructor is private' do
    expect{ described_class.new }.to raise_error(NoMethodError)
  end

  example 'seconds method basic functionality' do
    expect(described_class).to respond_to(:seconds)
    expect{ described_class.seconds }.not_to raise_error
  end

  example 'seconds method returns a plausible value' do
    expect(described_class.seconds).to be_kind_of(Integer)
    expect(described_class.seconds).to be > plausible_seconds
  end

  example 'minutes method basic functionality' do
    expect(described_class).to respond_to(:minutes)
    expect{ described_class.minutes }.not_to raise_error
  end

  example 'minutes method returns a plausible value' do
    expect(described_class.minutes).to be_kind_of(Integer)
    if ENV['CI']
      expect(described_class.minutes).to be >= 0
    else
      expect(described_class.minutes).to be > 0
    end
  end

  example 'hours method basic functionality' do
    expect(described_class).to respond_to(:hours)
    expect{ described_class.hours }.not_to raise_error
  end

  example 'hours method returns a plausible value' do
    expect(described_class.hours).to be_kind_of(Integer)
    expect(described_class.hours).to be >= 0
  end

  example 'days method basic functionality' do
    expect(described_class).to respond_to(:days)
    expect{ described_class.days }.not_to raise_error
  end

  example 'days method returns a plausible value' do
    expect(described_class.days).to be_kind_of(Integer)
    expect(described_class.days).to be >= 0
  end

  example 'uptime method basic functionality' do
    expect(described_class).to respond_to(:uptime)
    expect{ described_class.uptime }.not_to raise_error
  end

  example 'uptime method returns a non-empty string' do
    expect(described_class.uptime).to be_kind_of(String)
    expect(described_class.uptime.empty?).to be(false)
  end

  example 'uptime method does not accept any arguments', :unless => File::ALT_SEPARATOR do
    expect{ described_class.uptime(1) }.to raise_error(ArgumentError)
  end

  example 'uptime accepts a host name on Windows', :if => File::ALT_SEPARATOR do
    expect{ described_class.uptime(Socket.gethostname) }.not_to raise_error
  end

  example 'dhms method basic functionality' do
    expect(described_class).to respond_to(:dhms)
    expect{ described_class.dhms }.not_to raise_error
    expect(described_class.dhms).to be_kind_of(Array)
  end

  example 'dhms method returns an array of four elements' do
    expect(described_class.dhms).not_to be_empty
    expect(described_class.dhms.length).to eql(4)
  end

  example 'boot_time method basic functionality' do
    expect(described_class).to respond_to(:boot_time)
    expect{ described_class.boot_time }.not_to raise_error
  end

  example 'boot_time method returns a Time object' do
    expect(described_class.boot_time).to be_kind_of(Time)
  end

  example 'Uptime class cannot be instantiated' do
    expect{ described_class.new }.to raise_error(StandardError)
  end

  example 'Ensure that ffi functions are private' do
    methods = described_class.methods(false).map{ |e| e.to_s }
    expect(methods).not_to include('time', 'times')
  end
end
