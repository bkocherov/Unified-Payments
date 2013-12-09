Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name = "spree_unified_gateway"
  s.version = "2-0-stable"
  s.summary = "Integrate payment using UnifiedPayment service"

  s.required_rubygems_version = ">=2.0.0"

  s.author = "Manish Kangia"
  s.email = "manish.kangia@vinsol.com"

  s.add_dependency 'spree_core'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-rails',  '~> 2.10'
end