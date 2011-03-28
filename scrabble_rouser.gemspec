# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)
require "scrabble_rouser/version"

Gem::Specification.new do |s|
  # properties
  s.name        = "scrabble_rouser"
  s.version     = ScrabbleRouser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Petersen"]
  s.email       = ["jasonmp85@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Cheat at Scrabble}
  s.description = %q{Utilities and classes for generating optimal moves in
                     Scrabble and Scrabble-like games.}
  s.rubyforge_project = "scrabble_rouser"

  # dependencies
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'

  # files
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
