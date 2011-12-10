require 'ffi'

# The Sys module serves as a namespace only.
module Sys

  # The Uptime class encapsulates various bits of information regarding your
  # system's uptime, including boot time.
  class Uptime
    extend FFI::Library
    ffi_lib FFI::Library::LIBC

    # Error typically raised in one of the Uptime methods should fail.
    class Error < StandardError; end

    # The version of the sys-uptime library
    VERSION = '0.6.0'

    private

    # Hit this issue on Linux, not sure why
    begin
      find_type(:clock_t)
    rescue TypeError
      typedef(:long, :clock_t)
    end

    attach_function :strerror, [:int],     :string
    attach_function :sysconf,  [:int],     :long
    attach_function :time,     [:pointer], :time_t
    attach_function :times,    [:pointer], :clock_t

    private_class_method :strerror, :sysconf, :time, :times

    begin
      attach_function :sysctl, [:pointer, :uint, :pointer, :pointer, :pointer, :size_t], :int
      private_class_method :sysctl
    rescue FFI::NotFoundError
      # Do nothing, not supported.
    else
      attach_function :setutxent, [], :void
      attach_function :getutxent, [], :pointer
      attach_function :endutxent, [], :void
      private_class_method :setutxent, :getutxent, :endutxent
    end

    CTL_KERN      = 1   # Kernel
    KERN_BOOTTIME = 21  # Time kernel was booted
    TICKS         = 100 # Ticks per second (TODO: use sysconf)
    BOOT_TIME     = 2   # Boot time

    class Tms < FFI::Struct
      layout(
        :tms_utime, :clock_t,
        :tms_stime, :clock_t,
        :tms_cutime, :clock_t,
        :tms_cstime, :clock_t
      )
    end

    class Timeval < FFI::Struct
      layout(
        :tv_sec,  :long,
        :tv_usec, :long
      )
    end

    class ExitStatus < FFI::Struct
      layout(
        :e_termination, :short,
        :e_exit, :short
      )
    end

    class Utmpx < FFI::Struct
      layout(
        :ut_type, :short,
        :ut_pid, :pid_t,
        :ut_line, [:char, 32],
        :ut_id, :char,
        :ut_user, [:char, 32],
        :ut_host, [:char, 256],
        :ut_exit, ExitStatus,
        :ut_session, :long,
        :ut_tv, Timeval
      )
    end

    public

    # Returns a Time object indicating the time the system was last booted.
    #
    # Example:
    #
    #    Sys::Uptime.boot_time # => Mon Jul 13 06:08:25 -0600 2009
    #
    def self.boot_time
      if Config::CONFIG['host_os'] =~ /linux/i
        Time.now - self.seconds
      elsif defined? :sysctl
        tv = Timeval.new
        mib  = FFI::MemoryPointer.new(:int, 2).write_array_of_int([CTL_KERN, KERN_BOOTTIME])
        size = FFI::MemoryPointer.new(:long, 1).write_int(tv.size)

        if sysctl(mib, 2, tv, size, nil, 0) != 0
          raise SystemCallError, 'sysctl() - ' + strerror(FFI.errno)
        end

        Time.at(tv[:tv_sec], tv[:tv_usec])
      else
        begin
          setutxent()
          while ent = Utmpx.new(getutxent())
            if ent[:ut_type] == BOOT_TIME
              time = Time.at(ent[:ut_tv][:tv_sec], ent[:ut_tv][:tv_usec])
              break
            end
          end
        ensure
          endutxent()
        end
        time
      end
    end

    # Returns the total number of seconds of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.seconds => 118800
    #
    def self.seconds
      if Config::CONFIG['host_os'] =~ /linux/i
        begin
          IO.read('/proc/uptime').split.first.to_i
        rescue Exception => err
          raise Error, err
        end
      elsif defined? :sysctl
        tv   = Timeval.new
        mib  = FFI::MemoryPointer.new(:int, 2).write_array_of_int([CTL_KERN, KERN_BOOTTIME])
        size = FFI::MemoryPointer.new(:long, 1).write_int(tv.size)

        if sysctl(mib, 2, tv, size, nil, 0) != 0
          raise SystemCallError, 'sysctl() - ' + strerror(FFI.errno)
        end

        time(nil) - tv[:tv_sec]
      else
        tms = Tms.new
        times(tms) / TICKS
      end
    end

    # Returns the total number of minutes of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.minutes # => 678
    #
    def self.minutes
      seconds / 60
    end

    # Returns the total number of hours of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.hours # => 31
    #
    def self.hours
      seconds / 3600
    end

    # Returns the total number of days of uptime.
    #
    # Example:
    #
    #    Sys::Uptime.days # => 2
    #
    def self.days
      seconds / 86400
    end

    # Returns the uptime as a colon separated string, including days,
    # hours, minutes and seconds.
    #
    # Example:
    #
    #    Sys::Uptime.uptime # => "1:9:24:57"
    #
    def self.uptime
      secs  = seconds
      days  = secs / 86400
      secs  -= days * 86400
      hours = secs / 3600
      secs  -= hours * 3600
      mins  = secs / 60
      secs  -= mins * 60

      "#{days}:#{hours}:#{mins}:#{secs}"
    end

    # Returns the uptime as a four element array, including days, hours,
    # minutes and seconds.
    #
    # Example:
    #
    #    Sys::Uptime.dhms # => [1,9,24,57]
    #
    def self.dhms
      uptime.split(':')
    end
  end
end
