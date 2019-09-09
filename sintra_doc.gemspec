lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sinatra_doc/version"
Gem::Specification.new do |s|
  s.name        = "sinatra_doc"
  s.version     = SinatraDoc::VERSION
  s.summary     = "Sinatra Doc"
  s.description = "A documentation library for sinatra projects"
  s.authors     = [ "rradar" ]
  s.email       = "development@rradar.com"
  s.files       = Dir["lib/**/*.rb"]
  s.require_path = "lib"
  s.homepage    = "http://rradar.com"
  s.license     = "MIT"
  s.required_ruby_version = ">= 2.4.0"

  s.add_dependency "activesupport", ">= 4.2"
  s.add_dependency "json", "~> 2.0"
  s.add_development_dependency "activerecord", ">= 4.2"
  s.add_development_dependency "sinatra", "~> 2.0"
  s.add_development_dependency "sqlite3", "~> 1.3", ">= 1.3.6"
end
