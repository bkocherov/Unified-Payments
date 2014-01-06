$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "unified_payment/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "unified_payment"
  s.version     = UnifiedPayment::VERSION
  s.authors     = ["Manish Kangia"]
  s.email       = ["manish.kangia@vinsol.com"]
  s.homepage    = "TODO"
  s.summary     = "Interface to handle payments via UnifiedPayment for rails app"
  s.description = "TODO: Description of UnifiedPayment."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "> 3.0"

  s.add_development_dependency "sqlite3"
end