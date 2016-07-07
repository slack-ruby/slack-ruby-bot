require File.expand_path('../config/environment', __FILE__)

require 'slack-ruby-bot/version'
require 'slack-ruby-bot/support/loggable'
require 'slack-ruby-bot/about'
require 'slack-ruby-bot/config'
require 'slack-ruby-bot/hooks'

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

require 'slack-ruby-client'
require 'slack-ruby-bot/support/commands_helper'
require 'slack-ruby-bot/commands'
require 'slack-ruby-bot/client'
require 'slack-ruby-bot/server'
require 'slack-ruby-bot/app'
require 'slack-ruby-bot/bot'
