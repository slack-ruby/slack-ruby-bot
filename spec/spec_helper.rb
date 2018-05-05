require 'slack-ruby-bot/rspec'
require 'webmock/rspec'

module Giphy
  def self.env?
    ENV.key?('WITH_GIPHY') || ENV.key?('WITH_GIPHY_CLIENT')
  end
end
