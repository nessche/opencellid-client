# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "opencellid/version"

Gem::Specification.new do |s|
  s.name        = "opencellid-client"
  s.version     = Opencellid::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marco Sandrini"]
  s.email       = ["nessche@gmail.com"]
  s.homepage    = "https://github.com/nessche/opencellid-client"
  s.summary     = "A Ruby client for OpenCellID API"
  s.description = "A Ruby client for OpenCellID API"


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "rake"
  s.add_development_dependency "yard"
  s.add_development_dependency "redcarpet"
  # s.add_runtime_dependency "rest-client"
end