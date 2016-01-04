require 'spec_helper'

describe SlackRubyBot::Bot do
  let! :command do
    Class.new(SlackRubyBot::Bot) do
      command 'bot_spec' do |client, data, match|
        send_message client, data.channel, match['expression']
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  let(:client) { app.send(:client) }
  it 'sends a message' do
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: 'channel', text: 'message')
    app.send(:message, client, text: "#{SlackRubyBot.config.user} bot_spec message", channel: 'channel', user: 'user')
  end
end
