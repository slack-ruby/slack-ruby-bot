$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'rspec'
require 'rack/test'

require 'config/environment'
require 'slack-ruby-bot'

Dir[File.join(File.dirname(__FILE__), 'rspec/support', '**/*.rb')].each do |file|
  require file
end
