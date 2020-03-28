# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Dir[File.expand_path('../initializers', __dir__) + '/**/*.rb'].sort.each do |file|
  require file
end

require File.expand_path('application', __dir__)

require 'slack_ruby_bot'
