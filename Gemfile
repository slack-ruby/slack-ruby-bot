source 'http://rubygems.org'

gemspec

gem 'slack-ruby-client', github: 'slack-ruby/slack-ruby-client', branch: 'master'

gem ENV['CONCURRENCY'], require: false if ENV.key?('CONCURRENCY')

# rubocop:enable Bundler/OrderedGems

gem 'giphy', require: false if ENV.key?('WITH_GIPHY')
gem 'GiphyClient', require: false if ENV.key?('WITH_GIPHY_CLIENT')

group :test do
  gem 'slack-ruby-danger', '~> 0.1.0', require: false
end
