require 'ffi'

# The Sys module serves as a namespace only.
module Sys
   
   # The Uptime class encapsulates various bits of information regarding your
   # system's uptime, including boot time.
   class Uptime
      extend FFI::Library
      
      # Error typically raised in one of the Uptime methods should fail.
      class Error < StandardError; end
      
      # The version of the sys-uptime library
      VERSION = '0.6.0'

      private

      attach_function :strerror, [:int],     :string
      attach_function :sysconf,  [:int],     :long
      attach_function :time,     [:pointer], :time_t
      attach_function :times,    [:pointer], :clock_t

      begin
         attach_function :sysctl, [:pointer, :uint, :pointer, :pointer, :pointer, :size_t], :int
      rescue FFI::NotFoundError
         # Do nothing, not supported.
      end

      CTL_KERN = 1       # Kernel
      KERN_BOOTTIME = 21 # Time kernel was booted
      TICKS = 100        # Ticks per second (FIXME: use sysconf)

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

      public

      # Returns a Time object indicating the time the system was last booted.
      #
      # Example:
      #
      #    Sys::Uptime.boot_time # => Mon Jul 13 06:08:25 -0600 2009
      #
      def self.boot_time
         if defined? :sysctl
            tv = Timeval.new
            mib  = FFI::MemoryPointer.new(:int, 2).write_array_of_int([CTL_KERN, KERN_BOOTTIME])
            size = FFI::MemoryPointer.new(:long, 1).write_int(tv.size)

            if sysctl(mib, 2, tv, size, nil, 0) != 0
               raise SystemCallError, 'sysctl() - ' + strerror(FFI.errno)
            end

            Time.at(tv[:tv_sec], tv[:tv_usec])
         elsif Config::CONFIG['host_os'] =~ /linux/i
            Time.now - self.seconds
         else
            # TODO: setutxent/getutxent/endutxent
         end
      end

      # Returns the total number of seconds of uptime.
      #
      # Example:
      #
      #    Sys::Uptime.seconds => 118800
      #
      def self.seconds
         if defined? :sysctl
            tv   = Timeval.new
            mib  = FFI::MemoryPointer.new(:int, 2).write_array_of_int([CTL_KERN, KERN_BOOTTIME])
            size = FFI::MemoryPointer.new(:long, 1).write_int(tv.size)

            if sysctl(mib, 2, tv, size, nil, 0) != 0
               raise SystemCallError, 'sysctl() - ' + strerror(FFI.errno)
            end

            time(nil) - tv[:tv_sec]
         elsif Config::CONFIG['host_os'] =~ /linux/i
            begin
               IO.read(UPTIME_FILE).split.first.to_i
            rescue Exception => err
               raise Error, err
            end
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
