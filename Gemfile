source 'http://rubygems.org'
gemspec

# NOTE to test both load cases:when volume pricing override loads first
# and when sale products loads first) put gemspec call at top vs bottom

group :test do
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'guard-rspec'
    gem 'rb-fsevent'
    gem 'growl'
  end
end

gem 'spree_volume_pricing', git: 'https://github.com/spree-contrib/spree_volume_pricing.git', :branch => '3-0-stable'
gem 'spree', git: 'https://github.com/spree/spree.git', branch: '3-0-stable'
