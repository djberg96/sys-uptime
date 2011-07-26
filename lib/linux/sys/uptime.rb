# The Sys module serves as a namespace only.
module Sys

  # The Uptime class encapsulates various bits of information regarding your
  # system's uptime, including boot time.
  class Uptime

    # Error typically raised in one of the Uptime methods should fail.
    class Error < StandardError; end

    # The version of the sys-uptime library.
    VERSION = '0.5.4'

    # The file to read uptime information from.
    UPTIME_FILE = '/proc/uptime'

    # Returns the total number of seconds of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.seconds # => 118800
    #
    def self.seconds
      begin
        IO.read(UPTIME_FILE).split.first.to_i
      rescue Exception => err
        raise Error, err
      end
    end

    # Returns the total number of minutes of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.minutes # => 678
    #
    def self.minutes
      self.seconds / 60
    end

    # Returns the total number of hours of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.hours # => 31
    #
    def self.hours
      self.minutes / 60
    end

    # Returns the total number of days of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.days # => 2
    #
    def self.days
      self.hours / 24
    end

    # Returns the uptime as a colon separated string, including days,
    # hours, minutes and seconds.
    #
    # Example:
    #
    #    Sys::Uptime.uptime # => "1:9:24:57"
    #
    def self.uptime
      seconds = self.seconds
      days    = seconds / 86400
      seconds -= days * 86400
      hours   = seconds / 3600
      seconds -= hours * 3600
      minutes = seconds / 60
      seconds -= minutes * 60

      "#{days}:#{hours}:#{minutes}:#{seconds}"
    end

    # Returns the uptime as a four element array, including days, hours,
    # minutes and seconds.
    #
    # Example:
    #
    #    Sys::Uptime.dhms # => [1,9,24,57]
    #
    def self.dhms
      self.uptime.split(":")
    end

    # Returns the time the system was booted as a Time object.
    #
    # Example:
    #
    #    Sys::Uptime.boot_time
    #
    def self.boot_time
      Time.now - self.seconds
    end
  end
end
