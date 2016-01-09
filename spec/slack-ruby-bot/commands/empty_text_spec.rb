require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'empty_text'

      def self.call(client, data, _match)
        client.say(channel: data.channel)
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  let(:client) { app.send(:client) }
  it 'sends default text' do
    allow(Giphy).to receive(:random)
    expect(client).to receive(:message).with(channel: 'channel', text: '')
    app.send(:message, client, text: "#{SlackRubyBot.config.user} empty_text", channel: 'channel', user: 'user')
  end
end
