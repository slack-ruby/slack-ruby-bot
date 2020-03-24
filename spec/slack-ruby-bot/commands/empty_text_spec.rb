# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'empty_text'

      def self.call(client, data, _match)
        client.say(channel: data.channel)
      end
    end
  end
  it 'sends default text' do
    expect(message: "#{SlackRubyBot.config.user} empty_text", channel: 'channel', user: 'user').to respond_with_slack_message('')
  end
end
