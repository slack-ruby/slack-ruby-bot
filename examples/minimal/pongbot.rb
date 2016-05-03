require 'slack-ruby-bot'

class Bot < SlackRubyBot::Bot
  title 'ping'
  desc 'Sends you pong.'
  long_desc ''

  command 'ping' do |client, data, _match|
    client.say(text: 'pong', channel: data.channel)
  end
end

Bot.run
