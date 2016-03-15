require 'spec_helper'

describe SlackRubyBot::Bot do
  let! :command do
    Class.new(SlackRubyBot::Bot) do
      command 'bot_spec' do |client, data, match|
        client.say(channel: data.channel, text: match['expression'])
      end
    end
  end

  def app
    SlackRubyBot::Bot.instance
  end

  it 'sends a message' do
    expect(message: "#{SlackRubyBot.config.user} bot_spec message").to respond_with_slack_message('message')
  end
end
