# frozen_string_literal: true

require 'slack-ruby-bot'

class Bot < SlackRubyBot::Bot
  command 'ping' do |client, data, _match|
    client.say(text: 'pong', channel: data.channel)
  end
end

SlackRubyBot::Client.logger.level = Logger::WARN

Bot.run
