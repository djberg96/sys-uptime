## 0.8.0 - 7-Jul-2025
* Use sysconf instead of hard coded value for ticks on Unixy platforms that
  aren't Linux and don't define sysctl.

## 0.7.6 - 9-Apr-2023
* Constructor is now officially private, as are several constants that were
  never meant to be public.
* Lots of rubocop suggested updates.
* Minor refactoring for Windows.
* Minor updates, including Rakefile and gemspec metadata.

## 0.7.5 - 29-Oct-2020
* Switched docs to markdown format.
* Added a Gemfile.

## 0.7.4 - 18-Mar-2020
* Added a LICENSE file as per the requirements of the Apache-2.0 license.

## 0.7.3 - 31-Dec-2019
* Attempting to call Sys::Uptime.new will now raise an error. I thought
  this was already the case, but apparently one of the tests was bad.
* Added explicit .rdoc extensions to various text files so that github
  will display them nicely.
* Switched from test-unit to rspec as the testing framework of choice.
* Updated the gemspec to reflect the filename updates, as well as the
  added development dependency.

## 0.7.2 - 4-Nov-2018
* Added metadata to the gemspec.
* The VERSION constant is now frozen.
* Updated cert.

## 0.7.1 - 14-May-2016
* Altered internal layout, which also fixed a require bug. Thanks go
  to jkburges for the spot.
* Moved the VERSION constant into a single file shared by all platforms.

## 0.7.0 - 3-Oct-2015
* Changed license to Apache 2.0.
* Added a cert. This gem is now signed.
* Added a sys-uptime.rb file for convenience.
* Gem related tasks in the Rakefile now assume Rubygems 2.x.

## 0.6.2 - 8-Nov-2014
* Minor updates to gemspec and Rakefile.

## 0.6.1 - 22-Oct-2012
* Refactored a private method in the MS Windows source.
* Minor fix for one private method test.
* Fixed an RbConfig vs Config warning. Thanks Pedro Carrico.

## 0.6.0 - 11-Dec-2011
* Switched Unix code to use FFI.
* Removed all of the C related tasks from the Rakefile and added the gem:build
  and gem:install tasks.
* Internal directory layout changes, with appropriate changes to the gemspec.

## 0.5.3 - 7-May-2009
* Altered the Uptime.seconds implementation on Linux so that it works with
  both Ruby 1.8.x and 1.9.x. Thanks go to Alexey Chebotar for the spot.

## 0.5.2 - 13-Dec-2008
* Fixed a date/time issue in the Windows version caused by Ruby itself.
* Fixed the Uptime.seconds, Uptime.minutes and Uptime.hours methods on MS
  Windows.
* Renamed the test file to 'test_sys_uptime.rb'.
* Some minor updates to the Rakefile.

## 0.5.1 - 26-Jul-2007
* Fixed bug in the MS Windows version caused by incorrect parsing of an
  MS specific date format (caused by a bug in Ruby 1.8.6). Thanks go to
  Robert H. for the spot.
* Inlined the Rake installation tasks, so the install.rb file has been
  removed.
* Added an 'install_gem' Rake task, and updated the README installation
  instructions.

## 0.5.0 - 30-Mar-2007
* For platforms that use C code, the code now always uses the sysctl()
  function if supported by your system. This replaces the platform specific
  checks I was doing for the various BSD flavors.
* Fix for OS X - the Uptime.boot_time method now works.
* UptimeError is now Uptime::Error.
* Improved RDoc in the uptime.c source code.
* Added a Rakefile - users should now use the 'test' and 'install' rake tasks.
* Updates to the MANIFEST, README and uptime.txt files.

## 0.4.5 - 19-Nov-2006
* Internal layout changes, minor doc updates and gemspec improvements.
* No code changes.

## 0.4.4 - 30-Jun-2006
* Added inline rdoc documentation to the source files.
* Added a gemspec.

## 0.4.3 - 18-Dec-2005
* Changed the Linux version to pure Ruby.  The current method of determining
  uptime in unix.c does not work in Linux kernel 2.6+.  So, from now on it
  reads out of /proc/uptime.

## 0.4.2 - 6-May-2005
* Fixed a potential boot_time bug.
* Removed the version.h file.  It's no longer needed since the Windows
  version is pure Ruby.
* NetBSD 2.x and FreeBSD 5.x now supported.
* Removed the INSTALL file.  Installation instructions are now in
  the README file.
* Removed the uptime.rd file.  You can generate html documentation by
  running rdoc over the uptime.txt file.
* Made most documents rdoc friendly.
* Moved project to RubyForge.

## 0.4.1 - 14-Dec-2004
* Moved freebsd code into unix.c file.
* Should now work past 249 days (2**31) on systems that have utmpx.h.
* Fixed a bug with regards to boot_time, where it was possible that it would
  simply be empty.

## 0.4.0 - 8-Jul-2004
* Removed all reference to the CLK_TCK constant, as per documentation from
  Richard Stevens that it is deprecated and that sysconf() should be used
  instead (well, I knew about this, but ignored it until now).
* Scrapped the C version for Windows in favor of a pure Ruby version that
  uses win32ole + WMI.
* Added a boot_time method for Unix systems (Windows already had this).
* Added an UptimeError class on Unix systems (and replaced UptimeException
  on Windows).
* Modified an internal function to raise an UptimeError if the times()
  function fails.  Also, it now returns an unsigned long instead of a plain
  long.
* Replaced the two different test suites with a single, unified test suite.
* Cleaned up the extconf.rb script.  I now assume that TestUnit is installed.
* Removed the load_avg method (which was never advertised and which I hope
  you weren't using).  You can find a load_avg method in the sys-cpu package.
* Changed uptime.rd2 to uptime.rd to be consistent with my other packages.
* Removed the uptime.html file - you may generate that on your own.
* Added warranty and license info.

## 0.3.2 - 30-Dec-2003
* Cleaned up some warnings that showed up with -Wall on some unix platforms
  (int vs long format, explicit include)
* Minor test suite and extconf.rb changes

## 0.3.1 - 25-Jun-2003
* Modified test files to handle HP-UX extensions
* Minor doc updates
* Added the dhms() method.  Actually, this was in the 0.3.0
  release, I just forgot to mention it in this file :)

## 0.3.0 - 22-Jun-2003
* Added OS X support - thanks go to Mike Hall for the patch
* Fixed incorrect values in FreeBSD (again Mike Hall)
* Modified tc_unix.rb test suite to handle OS X, along with a bit
* of minor cleanup
* Removed VERSION class method.  Use the constant instead
* Separated FreeBSD/OS X source into its own file (freebsd.c).
  The #ifdefs were starting to get too ugly for me

## 0.2.1 - 13-May-2003
* Fixed bug in extconf.rb file, and made some major changes
* Modified test.rb for those without TestUnit
* Modified TestUnit tests - some bogus tests were removed
* Added a README file with some additional info
* Created a version.h file, so that I can keep the VERSION number
  in one place
* Docs automatically included in doc directory (i.e. no more interactive
  document creation)

## 0.2.0 - 13-Mar-2003
* Added MS Windows support
* Added a VERSION constant
* Added a test suite (for those with TestUnit installed)
* Internal directory layout change
* uptime.c is now split into unix.c and windows.c (and linked appropriately)
* Changelog and Manifest are now CHANGES and MANIFEST, respectively
* Many changes to extconf.rb

## 0.1.3 - 6-Jan-2003
* Added a VERSION class method
* Added a copyright notice
* Fixed up the docs a bit and moved them to the doc directory
* Changed the tarball name to match the RAA package name
* Modified test.rb script to make it better
* Changed install instructions slightly

## 0.1.2 - 25-Aug-2002
* Slight change to preprocessor commands to avoid redefining CLK_TCK on
  those systems that define it in time.h
* Added an INSTALL file

## 0.1.1 - 21-Jun-2002
* The CLK_TCK constant wasn't necessarily being set correctly, which could
  lead to some odd results.  This has been fixed.

## 0.1.0 - 17-Jun-2002
* Initial release
