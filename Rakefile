require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rspec/core/rake_task'

CLEAN.include("**/*.gem", "**/*.rbx", "**/*.rbc", "**/*.lock")

namespace 'gem' do
  desc 'Build the sys-uptime gem'
  task :create => [:clean] do
    require 'rubygems/package'
    spec = eval(IO.read('sys-uptime.gemspec'))
    spec.signing_key = File.join(Dir.home, '.ssh', 'gem-private_key.pem')
    Gem::Package.build(spec)
  end

  desc 'Install the sys-uptime gem'
  task :install => [:create] do
    file = Dir["*.gem"].first
    sh "gem install -l #{file}"
  end
end

desc "Run the test suite"
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
