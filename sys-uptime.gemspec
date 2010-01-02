require 'rubygems'

spec = Gem::Specification.new do |gem|
   gem.name         = 'sys-uptime'
   gem.version      = '0.5.3'
   gem.author       = 'Daniel J. Berger'
   gem.email        = 'djberg96@gmail.com'
   gem.homepage     = 'http://www.rubyforge.org/projects/sysutils'
   gem.platform     = Gem::Platform::RUBY
   gem.summary      = 'A Ruby interface for getting system uptime information.'
   gem.test_file    = 'test/test_sys_uptime.rb'
   gem.has_rdoc     = true
   gem.extra_rdoc_files  = ['CHANGES', 'README', 'MANIFEST', 'doc/uptime.txt']
   gem.rubyforge_project = 'sysutils'
   gem.files = Dir["doc/*"] + Dir["test/*"]
   gem.files.delete_if{ |item| item.include?('CVS') }

   gem.description = <<-EOF
      The sys-uptime library is a simple interface for gathering uptime
      information. You can retrieve data in seconds, minutes, days, hours,
      or all of the above.
   EOF
end

if $PROGRAM_NAME == __FILE__
   case Config::CONFIG['host_os']
      when /windows|win32|cygwin|mingw|dos/
         File.rename('lib/sys/windows.rb', 'lib/sys/uptime.rb')
         spec.required_ruby_version = '>= 1.8.2'
         spec.files += ['lib/sys/uptime.rb']
         spec.platform = Gem::Platform::CURRENT
      when /linux/
         File.rename('lib/sys/linux.rb', 'lib/sys/uptime.rb')
         spec.required_ruby_version = '>= 1.8.0'
         spec.files += ['lib/sys/uptime.rb']
         spec.platform = Gem::Platform::CURRENT
      else
         spec.required_ruby_version = '>= 1.8.0'
         spec.extensions = ['ext/extconf.rb']
         spec.files += Dir["ext/**/*"]
         spec.extra_rdoc_files << 'ext/sys/uptime.c'
   end
   
   Gem::Builder.new(spec).build
end
