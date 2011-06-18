# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "polleverywhere/version"

Gem::Specification.new do |s|
  s.name        = "polleverywhere"
  s.version     = Polleverywhere::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brad Gessler, Steel Fu"]
  s.email       = ["geeks@polleverywhere.com"]
  s.homepage    = "http://www.polleverywhere.com/"
  s.summary     = %q{Integration Poll Everywhere into your Ruby applications}
  s.description = %q{An easy way to integrate Poll Everywhere into your Ruby applications.}

  s.rubyforge_project = "polleverywhere"
  s.add_dependency "json"
  s.add_development_dependency "rest-client", "~> 1.6.3"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end