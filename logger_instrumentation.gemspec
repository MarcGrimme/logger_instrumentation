# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logger_instrumentation/version'

Gem::Specification.new do |spec|
  spec.name          = "logger_instrumentation"
  spec.version       = LoggerInstrumentation::VERSION
  spec.authors       = ["Marc Grimme"]
  spec.email         = ["marc.grimme@googlemail.com"]

  spec.summary       = %q{Easily abstract ActiveSupport::Notification.instrumenation to use for logging.}
  spec.description   = %q{This gem should make it easy to abstract ActiveSupport::Notification.instrumenation behind
  a logger similar structure so that you can integrate it in your code with ease.}
  spec.homepage      = "https://github.com/MarcGrimme/logger_instrumenation"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = ""
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_runtime_dependency 'logstasher', '~> 1.0.0'
  spec.add_runtime_dependency 'logstash-event', '~> 1.2.0'
  spec.add_runtime_dependency 'activesupport', '>= 4.0'

  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rails', '>= 4.0')
end
