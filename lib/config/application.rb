$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Dir[File.expand_path('../../initializers', __FILE__) + '/**/*.rb'].each do |file|
  require file
end

require File.expand_path('../application', __FILE__)

require 'slack_ruby_bot'
