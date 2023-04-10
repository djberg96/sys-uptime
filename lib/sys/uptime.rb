# frozen_string_literal: true

if File::ALT_SEPARATOR
  require_relative 'windows/sys/uptime'
else
  require_relative 'unix/sys/uptime'
end

# The Sys module serves as a namespace only.
module Sys
  # The Uptime class serves as a base singleton class to hang uptime related methods on.
  class Uptime
    # The version of the sys-uptime library
    VERSION = '0.7.6'

    private_class_method :new
  end
end
