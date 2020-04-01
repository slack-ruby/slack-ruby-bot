# frozen_string_literal: true

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end

  let(:client) { subject.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }

  context 'default' do
    it 'does not respond to bot messages' do
      expect(client).to_not receive(:message)
      message_hook.call(client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user} hi", subtype: 'bot_message'))
    end
  end
  context 'with allow_bot_messages=true' do
    before do
      SlackRubyBot::Config.allow_bot_messages = true
    end
    it 'responds to self' do
      expect(client).to receive(:message)
      message_hook.call(client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user} hi", subtype: 'bot_message'))
    end
  end
end
