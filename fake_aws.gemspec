# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fake_aws/version'

Gem::Specification.new do |spec|
  spec.name          = "fake_aws"
  spec.version       = FakeAWS::VERSION
  spec.authors       = ["Pete Yandell", "Luke Arndt"]
  spec.email         = ["pete@notahat.com", "luke@arndt.io"]
  spec.description   = %q{A subset of AWS as a Rack app, for dev and testing}
  spec.summary       = %q{A subset of AWS (so far just a small proportion of S3) implemented as a Rack app, useful for development and testing.}
  spec.homepage      = "https://github.com/envato/fake_aws"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "finer_struct", "~> 0.0.5"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "nori", "~> 2.3.0"
end
