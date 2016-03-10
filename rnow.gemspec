# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rnow/version'

Gem::Specification.new do |spec|
  spec.name          = "rnow"
  spec.version       = Rnow::VERSION
  spec.authors       = ["Soheil Eizadi"]
  spec.email         = ["seizadi@gmail.com"]
  spec.summary       = %q{Ruby wrapper for Oracle RightNow REST API}
  spec.description   = %q{Ruby Gem for Oracle RightNow REST interface, was available with version 15.05 (May 2015). Use this gem to list, create, and delete RightNow organizations, contacts and incdents.}
  spec.homepage      = "https://github.com/seizadi/rnow"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4.0"

  spec.add_runtime_dependency "faraday", "~> 0.9.2"
  spec.add_runtime_dependency "faraday_middleware", "~> 0.10.0"
  spec.add_runtime_dependency "jsonapi-serializers", "~> 0.6.4"
end
