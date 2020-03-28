# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'send_message_spec' do |client, data, match|
        client.say(channel: data.channel, text: match['expression'])
      end
    end
  end
  it 'sends a message' do
    expect(message: "#{SlackRubyBot.config.user} send_message_spec message").to respond_with_slack_message('message')
  end
end
