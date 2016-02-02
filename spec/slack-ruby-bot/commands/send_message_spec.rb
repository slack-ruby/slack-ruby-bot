require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'send_message_spec' do |client, data, match|
        client.say(channel: data.channel, text: match['expression'])
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  let(:client) { app.send(:client) }
  it 'sends a message' do
    expect(client).to receive(:message).with(channel: 'channel', text: 'message')
    app.send(:message, client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user} send_message_spec message", channel: 'channel', user: 'user'))
  end
end
