$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lazy_json_scaffold/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name        = "lazy-json-scaffold"
  gem.version     = LazyJsonScaffold::VERSION
  gem.authors     = ["Russell Scheerer"]
  gem.email       = ["russell.scheerer@gmail.com"]
  gem.homepage    = "https://github.com/scheerer/lazy-json-scaffold"
  gem.summary     = ""
  gem.description = ""
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", "~> 4.1.0"

  gem.add_development_dependency "sqlite3"
end
