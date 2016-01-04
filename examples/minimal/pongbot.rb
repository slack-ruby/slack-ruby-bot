require 'slack-ruby-bot'

class Bot < SlackRubyBot::Bot
  command 'ping' do |client, data, _match|
    client.message text: 'pong', channel: data.channel
  end
end

Bot.run
