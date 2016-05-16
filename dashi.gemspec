# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dashi/version'

Gem::Specification.new do |spec|
  spec.name          = "dashi"
  spec.version       = Dashi::VERSION
  spec.authors       = ["Dylan Lacey"]
  spec.email         = ["github@dylanlacey.com"]
  spec.summary       = "Transform Sauce Labs logs back into tests."
  spec.description   = "Got a sauce.log describing a test but lost the test
  itself?  No fear!  Dashi will use the command as they happened to reconstruct
  tests according to a set of language grammar rules."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.executables << "dashi"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
