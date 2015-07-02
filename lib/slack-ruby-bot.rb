require File.expand_path('../config/environment', __FILE__)

require 'slack-ruby-bot/version'
require 'slack-ruby-bot/about'
require 'slack-ruby-bot/config'
require 'slack-ruby-bot/hooks'
require 'slack-ruby-bot/commands'
require 'slack-ruby-bot/app'

module SlackRubyBot
  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end
