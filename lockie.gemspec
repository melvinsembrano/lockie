$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "lockie/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "lockie"
  spec.version     = Lockie::VERSION
  spec.authors     = ["Melvin Sembrano"]
  spec.email       = ["melvinsembrano@gmail.com"]
  spec.homepage    = "https://github.com/melvinsembrano/lockie"
  spec.summary     = "Drop in password and JWT token authentication for Ruby on Rails"
  spec.description = "Drop in password and JWT token authentication for Ruby on Rails"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.2"
  spec.add_dependency "warden", "~> 1.2"
  spec.add_dependency "jwt", "~> 2.1"

  spec.add_development_dependency "sqlite3", "~> 1.4.1"
  spec.add_development_dependency "bcrypt", "~> 3.1.7"
  # spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "byebug", "~> 11.1.3"
end
