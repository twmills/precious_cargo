# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "precious_cargo/version"

Gem::Specification.new do |s|
  s.name        = "precious_cargo"
  s.version     = PreciousCargo::VERSION
  s.authors     = ["Theo Mills"]
  s.email       = ["twmills@twmills.com"]
  s.homepage    = "https://github.com/twmills/precious_cargo"
  s.summary     = %q{Secure large (or small) amounts of data for transfer over web services.}
  s.description = %q{PreciousCargo encapsulates a specific best practice when encrypting large (or small) amounts of data, normally to transmit over the wire via a web service. The strategy is not really complex, but it wasn't readily apparent when I was looking for a solution. Therefore I wrote this gem to make it convenient to not only apply this strategy, but to also make this best practice more easily discovered (hopefully).}

  s.rubyforge_project = "precious_cargo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "faker"
  s.add_runtime_dependency "gibberish"
end
