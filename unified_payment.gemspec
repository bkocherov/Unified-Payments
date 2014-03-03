$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "unified_payment/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "unified_payment"
  s.version     = UnifiedPayment::VERSION
  s.author      = ["Manish Kangia", "Sushant Mittal"]
  s.email       = ["info@vinsol.com"]
  s.homepage    = "http://vinsol.com"
  s.summary     = "Interface to handle payments via UnifiedPayment for rails app."
  s.description = "Interface to handle payments via UnifiedPayment for rails app."

  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "> 3.0"
end
