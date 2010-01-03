require 'rubygems'

Gem::Specification.new do |spec|
  spec.name      = 'sys-uptime'
  spec.version   = '0.6.0'
  spec.author    = 'Daniel J. Berger'
  spec.license   = 'Artistic 2.0'
  spec.email     = 'djberg96@gmail.com'
  spec.homepage  = 'http://www.rubyforge.org/projects/sysutils'
  spec.platform  = Gem::Platform::RUBY
  spec.summary   = 'A Ruby interface for getting system uptime information.'
  spec.test_file = 'test/test_sys_uptime.rb'
  spec.has_rdoc  = true
  spec.files     = Dir["**/*"].reject{ |f| f.include?('git') }

  spec.extra_rdoc_files  = ['CHANGES', 'README', 'MANIFEST']
  spec.rubyforge_project = 'sysutils'

  spec.add_dependency('ffi', '>= 0.5.0')

  spec.description = <<-EOF
    The sys-uptime library is a simple interface for gathering uptime
    information. You can retrieve data in seconds, minutes, days, hours,
    or all of the above.
  EOF
end
