require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

desc "Clean the build files for the sys-uptime source for UNIX systems"
task :clean do
  Dir["**/*.rbc"].each{ |f| File.delete(f) } # Rubinius
  Dir["*.gem"].each{ |f| File.delete(f) }

  rm_rf('sys') if File.exists?('sys')
  rm_rf('lib/sys/uptime.rb') if File.exists?('lib/sys/uptime.rb')

  unless Config::CONFIG['host_os'] =~ /mswin|win32|mingw|cygwin|dos|linux/i
    Dir.chdir('ext') do
      build_file = File.join('sys', 'uptime.' + Config::CONFIG['DLEXT'])
      sh 'make distclean' if File.exists?(build_file)
      rm_rf build_file if File.exists?(build_file)
    end
  end
end

desc "Build the sys-uptime package on UNIX systems (but don't install it)"
task :build => [:clean] do
  Dir.chdir('ext') do
    unless Config::CONFIG['host_os'] =~ /mswin|win32|mingw|cygwin|dos|linux/i
      ruby 'extconf.rb'
      sh 'make'
      build_file = 'uptime.' + Config::CONFIG['DLEXT']
      cp(build_file, 'sys')
    end
  end
end

if Config::CONFIG['host_os'] =~ /mswin|win32|mingw|cygwin|dos|linux/i
  desc "Install the sys-uptime package"
  task :install do
    dest = File.join(Config::CONFIG['sitelibdir'], 'sys')
    file = File.join(dest, 'uptime.rb')

    Dir.mkdir(dest) unless File.exists? dest

    if Config::CONFIG['host_os'] =~ /linux/i
      cp 'lib/sys/linux.rb', file, :verbose => true
    else
      cp 'lib/sys/windows.rb', file, :verbose => true
    end
  end
else
  desc "Install the sys-uptime package"
  task :install => [:build] do
    Dir.chdir('ext') do
      sh 'make install'
    end
  end
end

desc "Install the sys-uptime package as a gem"
task :install_gem do
  ruby 'sys-uptime.gemspec'
  file = Dir["*.gem"].first
  sh "gem install #{file}"
end

desc "Run the example program"
task :example => [:build] do
  Dir.mkdir('sys') unless File.exists?('sys')
  if Config::CONFIG['host_os'] =~ /mswin|win32|mingw|cygwin|dos|linux/i
    if Config::CONFIG['host_os'].match('linux')
      FileUtils.cp('lib/sys/linux.rb', 'sys/uptime.rb')
    else
      FileUtils.cp('lib/sys/windows.rb', 'sys/uptime.rb')
    end
  else
    build_file = 'ext/uptime.' + Config::CONFIG['DLEXT']
    FileUtils.cp(build_file, 'sys')
  end
  sh 'ruby -I. examples/uptime_test.rb'
end

desc "Run the test suite"
Rake::TestTask.new("test") do |t|
  if Config::CONFIG['host_os'] =~ /mswin|win32|mingw|cygwin|dos|linux/i
    if Config::CONFIG['host_os'].match('linux')
      FileUtils.cp('lib/sys/linux.rb', 'lib/sys/uptime.rb')
    else
      FileUtils.cp('lib/sys/windows.rb', 'lib/sys/uptime.rb')
    end
  else
    task :test => :build
    t.libs << 'ext'
    t.libs.delete('lib')
  end
   
  t.warning = true
  t.verbose = true
end

task :default => :test
