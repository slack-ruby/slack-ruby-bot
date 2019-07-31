source 'http://rubygems.org'

gemspec

if ENV.key?('CONCURRENCY')
  case ENV['CONCURRENCY']
  when 'async-websocket'
    gem 'async-websocket', '~> 0.8.0', require: false
  else
    gem ENV['CONCURRENCY'], require: false
  end
end

# rubocop:enable Bundler/OrderedGems

gem 'giphy', require: false if ENV.key?('WITH_GIPHY')
gem 'GiphyClient', require: false if ENV.key?('WITH_GIPHY_CLIENT')

group :test do
  gem 'slack-ruby-danger', '~> 0.1.0', require: false
end
