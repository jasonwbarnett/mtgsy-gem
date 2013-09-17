# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mtgsy/version'

Gem::Specification.new do |spec|
  spec.name          = "mtgsy"
  spec.version       = Mtgsy::VERSION
  spec.authors       = ["Jason Barnett"]
  spec.email         = ["jason.w.barnett@gmail.com"]
  spec.description   = %q{This is a ruby library for interacting with mtgsy (CloudFloor DNS).}
  spec.summary       = %q{}
  spec.homepage      = "https://github.com/jasonwbarnett/mtgsy-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "mechanize", "~> 2.7"
  #spec.add_runtime_dependency "ipaddress", "~> 0.8"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
