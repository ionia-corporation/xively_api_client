# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xively_api_client/version'

Gem::Specification.new do |spec|
  spec.name          = "xively_api_client"
  spec.version       = XivelyApiClient::VERSION
  spec.authors       = ["Jose Piccioni"]
  spec.email         = ["josepiccioni@gmail.com"]
  spec.summary       = %q{Lightweight API client for xively.}
  spec.description   = %q{Description: TBD}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "json"

end
