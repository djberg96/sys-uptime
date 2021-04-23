# frozen_string_literal: true

require 'win32ole'
require 'socket'
require 'date'
require 'time'

# The Sys module serves as a namespace only.
module Sys
  # The Uptime class encapsulates various bits of information regarding your
  # system's uptime, including boot time.
  class Uptime
    # Error typically raised in one of the Uptime methods should fail.
    class Error < StandardError; end

    # You cannot instantiate an instance of Sys::Uptime.
    private_class_method :new

    # Returns the boot time as a Time object.
    #
    # Example:
    #
    #    Sys::Uptime.boot_time # => Fri Dec 12 20:18:58 -0700 2008
    #
    def self.boot_time(host = Socket.gethostname)
      cs = "winmgmts://#{host}/root/cimv2"
      begin
        wmi = WIN32OLE.connect(cs)
      rescue WIN32OLERuntimeError => err
        raise Error, err
      else
        query = 'select LastBootupTime from Win32_OperatingSystem'
        result = wmi.ExecQuery(query).itemIndex(0).LastBootupTime
        Time.parse(result.split('.').first)
      end
    end

    # Calculates and returns the number of days, hours, minutes and
    # seconds the +host+ has been running as a colon-separated string.
    #
    # The localhost is used if no +host+ is provided.
    #
    # Example:
    #
    #    Sys::Uptime.uptime # => "1:9:55:11"
    #
    def self.uptime(host = Socket.gethostname)
      get_dhms(host).join(':')
    end

    # Calculates and returns the number of days, hours, minutes and
    # seconds the +host+ has been running as a four-element Array.
    # The localhost is used if no +host+ is provided.
    #
    # Example:
    #
    #    Sys::Uptime.dhms # => [1, 9, 55, 11]
    #
    def self.dhms(host = Socket.gethostname)
      get_dhms(host)
    end

    # Returns the total number of days the system has been up on +host+,
    # or the localhost if no host is provided.
    #
    # Example:
    #
    #    Sys::Uptime.days # => 1
    #
    def self.days(host = Socket.gethostname)
      hours(host) / 24
    end

    # Returns the total number of hours the system has been up on +host+,
    # or the localhost if no host is provided.
    #
    # Example:
    #
    #    Sys::Uptime.hours # => 33
    #
    def self.hours(host = Socket.gethostname)
      minutes(host) / 60
    end

    # Returns the total number of minutes the system has been up on +host+,
    # or the localhost if no host is provided.
    #
    # Example:
    #
    #    Sys::Uptime.minutes # => 1980
    #
    def self.minutes(host = Socket.gethostname)
      seconds(host) / 60
    end

    # Returns the total number of seconds the system has been up on +host+,
    # or the localhost if no host is provided.
    #
    # Example:
    #
    #    Sys::Uptime.seconds # => 118800
    #
    def self.seconds(host = Socket.gethostname)
      get_seconds(host)
    end

    private

    # Converts a string in the format '20040703074625.015625-360' into a
    # Ruby Time object.
    #
    def self.parse_ms_date(str)
      return if str.nil?
      Time.parse(str.split('.').first)
    end

    private_class_method :parse_ms_date

    # Get the actual days, hours, minutes and seconds since boot using WMI.
    #
    def self.get_dhms(host)
      seconds = get_seconds(host)

      days = (seconds / 86400).to_i
      seconds -= days * 86400
      hours = seconds / 3600
      seconds -= hours * 3600
      minutes = seconds / 60
      seconds -= minutes * 60

      [days, hours, minutes, seconds]
    end

    private_class_method :get_dhms

    # Returns the number of seconds since boot.
    #
    def self.get_seconds(host)
      (Time.now - boot_time(host)).to_i
    end

    private_class_method :get_seconds
  end
end
