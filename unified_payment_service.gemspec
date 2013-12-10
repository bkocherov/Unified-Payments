Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name = "unified_payment_service"
  s.version = "2.0.3"
  s.summary = "Integrate payment using UnifiedPayment service"

  s.required_rubygems_version = ">=2.0.0"

  s.author = "Manish Kangia"
  s.email = "manish.kangia@vinsol.com"

  s.files = `git ls-files`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  # s.add_dependency 'spree_core'
  # s.add_development_dependency 'database_cleaner'
  # s.add_development_dependency 'rspec-rails',  '~> 2.10'
end