require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include("**/*.gem", "**/*.rbx", "**/*.rbc")

namespace 'gem' do
  desc 'Build the sys-uptime gem'
  task :create => [:clean] do
    spec = eval(IO.read('sys-uptime.gemspec'))
    
    if File::ALT_SEPARATOR
      spec.require_paths = ['lib', 'lib/windows']
      spec.platform = Gem::Platform::CURRENT
      spec.platform.cpu = 'universal'
      spec.platform.version = nil
    else
      spec.require_paths = ['lib', 'lib/unix']
      spec.add_dependency('ffi', '>= 1.0.0')
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
  if File::ALT_SEPARATOR
    t.libs << 'lib/windows'
  else
    t.libs << 'lib/unix'
  end

  t.warning = true
  t.verbose = true
end

task :default => :test
