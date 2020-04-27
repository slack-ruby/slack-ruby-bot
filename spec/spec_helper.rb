# frozen_string_literal: true

require 'slack-ruby-bot/rspec'
require 'webmock/rspec'
require_relative 'support/vcr'

module WithGiphy
  def self.env?
    ENV.key?('WITH_GIPHY') || ENV.key?('WITH_GIPHY_CLIENT')
  end
end
