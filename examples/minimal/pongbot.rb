require 'slack-ruby-bot'

module PongBot
  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    def self.call(data, _command, _arguments)
      send_message data.channel, 'pong'
    end
  end
end

PongBot::App.instance.run
