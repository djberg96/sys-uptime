require 'rake'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include("**/*.gem", "**/*.rbx", "**/*.rbc")

namespace 'gem' do
  desc 'Build the sys-uptime gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('sys-uptime.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    
    if File::ALT_SEPARATOR
      spec.platform = Gem::Platform::CURRENT
      spec.platform.cpu = 'universal'
      spec.platform.version = nil
    else
      spec.add_dependency('ffi', '>= 1.0.0')
    end

    Gem::Package.build(spec, true)
  end

  desc 'Install the sys-uptime gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
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
