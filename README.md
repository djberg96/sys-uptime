[![Ruby](https://github.com/djberg96/sys-uptime/actions/workflows/ruby.yml/badge.svg)](https://github.com/djberg96/sys-uptime/actions/workflows/ruby.yml)

## Description
A Ruby interface for getting system uptime information.

## Prerequisites
ffi 0.1.0 or later on Unixy platforms.

## Installation

`gem install sys-uptime`

## Synopsis
```
require 'sys-uptime'
include Sys

# Get everything
p Uptime.uptime
p Uptime.dhms.join(', ')

# Get individual units
p Uptime.days
p Uptime.hours
p Uptime.minutes
p Uptime.seconds

# Get the boot time
p Uptime.boot_time
```

## Notes
On MS Windows the +Uptime.uptime+ and +Uptime.boot_time+ methods optionally
takes a host name as a single argument. The default is localhost.

The current time, users and load average are not included in this library
module, even though you may be used to seeing them with the command
line version of +uptime+.

## Known Bugs
None that I am aware of. Please log any bugs you find on the project
website at https://github.com/djberg96/sys-uptime.

## Questions
"Doesn't Struct::Tms do this?" - No.
    
## License
Apache-2.0
    
## Copyright
Copyright 2002-2019, Daniel J. Berger

All Rights Reserved. This module is free software. It may be used,
redistributed and/or modified under the same terms as Ruby itself.
    
## Warranty
This library is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantability and fitness for a particular purpose.

## Acknowledgements
Andrea Fazzi for help with the FFI version.

Mike Hall for help with the BSD side of things for the original C code.

Ola Eriksson, whose source code I shamelessly plagiarized to get a better
implementation for systems that have the utmpx.h header file for the
original C code.

## Author
Daniel J. Berger
