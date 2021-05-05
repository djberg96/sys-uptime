require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'sys-uptime'
  spec.version    = '0.7.5'
  spec.author     = 'Daniel J. Berger'
  spec.license    = 'Apache-2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'https://github.com/djberg96/sys-uptime'
  spec.summary    = 'A Ruby interface for getting system uptime information.'
  spec.test_file  = 'spec/sys_uptime_spec.rb'
  spec.files      = Dir["**/*"].reject{ |f| f.include?('git') }
  spec.cert_chain = ['certs/djberg96_pub.pem']

  if File::ALT_SEPARATOR
    spec.platform = Gem::Platform.new(['universal', 'mingw32'])
  else
    spec.add_dependency('ffi', '~> 1.1')
  end

  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec', '~> 3.9')

  spec.metadata = {
    'homepage_uri'      => 'https://github.com/djberg96/sys-uptime',
    'bug_tracker_uri'   => 'https://github.com/djberg96/sys-uptime/issues',
    'changelog_uri'     => 'https://github.com/djberg96/sys-uptime/blob/main/CHANGES.md',
    'documentation_uri' => 'https://github.com/djberg96/sys-uptime/wiki',
    'source_code_uri'   => 'https://github.com/djberg96/sys-uptime',
    'wiki_uri'          => 'https://github.com/djberg96/sys-uptime/wiki'
  }

  spec.description = <<-EOF
    The sys-uptime library is a simple interface for gathering uptime
    information. You can retrieve data in seconds, minutes, days, hours,
    or all of the above.
  EOF
end
