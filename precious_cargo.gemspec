# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "precious_cargo/version"

Gem::Specification.new do |s|
  s.name        = "precious_cargo"
  s.version     = PreciousCargo::VERSION
  s.authors     = ["Theo Mills"]
  s.email       = ["twmills@twmills.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "precious_cargo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "faker"
  # s.add_runtime_dependency "rest-client"
end
