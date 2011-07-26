require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

CLEAN.include(
  '**/*.gem',                # Gem files
  '**/*.rbc',                # Rubinius
  '**/*.o',                  # C object file
  '**/*.log',                # Ruby extension build log
  '**/Makefile',             # C Makefile
  '**/conftest.dSYM',        # OS X build directory
  "**/*.#{CONFIG['DLEXT']}", # C shared object
  'lib/sys/uptime.rb'        # Renamed source file
)

desc "Build the sys-uptime library on UNIX systems"
task :build => [:clean] do
  Dir.chdir('ext') do
    unless Config::CONFIG['host_os'] =~ /windows|mswin|win32|mingw|cygwin|dos|linux/i
      ruby 'extconf.rb'
      sh 'make'
    end
  end
end

namespace :gem do
  desc "Create the gem for the sys-uptime library"
  task :create => [:clean] do
    spec = eval(IO.read('sys-uptime.gemspec'))

    case Config::CONFIG['host_os']
      when /windows|win32|cygwin|mingw|dos|mswin/
        spec.platform = Gem::Platform::CURRENT
        spec.platform.cpu = 'universal'
        spec.require_paths = ['lib', 'lib/windows'] 
      when /linux/
        spec.platform = Gem::Platform.new('universal-linux')
        spec.require_paths = ['lib', 'lib/linux'] 
      else
        spec.platform = Gem::Platform::RUBY
        spec.extensions = ['ext/extconf.rb']
        spec.extra_rdoc_files << 'ext/sys/uptime.c'
    end

    Gem::Builder.new(spec).build
  end

  desc "Install the sys-uptime library"
  task :install => [:create] do
    gem_name = Dir['*.gem'].first
    sh "gem install #{gem_name}"
  end
end

task :example => [:build] do
  case Config::CONFIG['host_os']
    when /windows|win32|cygwin|mingw|dos|mswin/
      path = 'lib/windows'
    when /linux/
      path = 'lib/linux'
    else
      path = 'ext'
  end
  sh "ruby -I#{path} examples/uptime_example.rb" 
end

desc "Run the test suite"
Rake::TestTask.new("test") do |t|
  task :test => :build
  t.libs << 'test' << '.'
  t.warning = true
  t.verbose = true

  case Config::CONFIG['host_os']
    when /windows|win32|cygwin|mingw|dos|mswin/
      t.libs << 'lib/windows'
    when /linux/
      t.libs << 'lib/linux'
  end
end

task :default => :test
