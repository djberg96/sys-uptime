require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rbconfig'
include Config

namespace 'gem' do
  desc 'Build the sys-uptime gem'
  task :build do
    spec = eval(IO.read('sys-uptime.gemspec'))
    
    if Config::CONFIG['host_os'] =~ /mswin32|mingw|cygwin|dos|windows/i
      spec.require_paths = ['lib', 'lib/windows']
    else
      spec.require_paths = ['lib', 'lib/unix']
      spec.add_dependency('ffi', '>= 0.5.0')
    end

    Gem::Builder.new(spec).build
  end

  desc 'Install the sys-uptime gem'
  task :install => [:build] do
    file = Dir["*.gem"].first
    sh "gem install #{file}"
  end
end

desc "Run the test suite"
Rake::TestTask.new do |t|
  if Config::CONFIG['host_os'] =~ /mswin32|mingw|cygwin|dos|windows/i
    t.libs << 'lib/windows'
  else
    t.libs << 'lib/unix'
  end

  t.warning = true
  t.verbose = true
end
