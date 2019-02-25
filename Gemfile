source 'http://rubygems.org'

gemspec

gem ENV['CONCURRENCY'], require: false if ENV.key?('CONCURRENCY')

# rubocop:enable Bundler/OrderedGems

gem 'giphy', require: false if ENV.key?('WITH_GIPHY')
gem 'GiphyClient', require: false if ENV.key?('WITH_GIPHY_CLIENT')

group :test do
  gem 'slack-ruby-danger', '~> 0.1.0', require: false
end
