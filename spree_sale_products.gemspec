lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_sale_products/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_sale_products'
  s.version     = SpreeSaleProducts.version
  s.summary     = 'Adds a sale price field to Spree::Product'
  s.description = 'Adds a sale price field to Spree::Product. Works with spree_volume_pricing'
  s.required_ruby_version = '>= 2.1.0'

  s.author            = 'Michael Bianco'
  s.email             = 'mike@cliffsidemedia.com'
  s.homepage          = 'http://github.com/iloveitaly/spree_sale_products'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.0'

  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'capybara', '~> 2.4.4'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'rspec-rails', '~> 3.2.0'
  s.add_development_dependency 'ffaker', '>= 1.32.1'
  s.add_development_dependency 'sqlite3', '>= 1.3.10'
end
