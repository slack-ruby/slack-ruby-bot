source 'http://rubygems.org'

gemspec

gem ENV['CONCURRENCY'], require: false if ENV.key?('CONCURRENCY')
gem 'giphy', require: false if ENV.key?('WITH_GIPHY')
gem 'danger', '~> 2.0'
