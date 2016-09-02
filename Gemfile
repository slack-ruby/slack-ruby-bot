source 'http://rubygems.org'

gemspec

gem ENV['CONCURRENCY'], require: false if ENV.key?('CONCURRENCY')
gem 'giphy', require: false if ENV.key?('WITH_GIPHY')
gem 'danger', '~> 3.1.1'
gem 'danger-changelog', '~> 0.1'
