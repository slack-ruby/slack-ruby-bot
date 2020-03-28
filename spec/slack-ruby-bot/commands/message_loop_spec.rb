# frozen_string_literal: true

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end

  let(:client) { subject.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }

  before do
    allow(client).to receive(:self).and_return(Hashie::Mash.new('id' => 'UDEADBEEF'))
  end

  context 'default' do
    it 'does not respond to self' do
      expect(client).to_not receive(:message)
      message_hook.call(client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user} hi", channel: 'channel', user: 'UDEADBEEF'))
    end
  end
  context 'with allow_message_loops=true' do
    before do
      SlackRubyBot::Config.allow_message_loops = true
    end
    it 'responds to self' do
      expect(message: "#{SlackRubyBot.config.user} hi").to respond_with_slack_message('Hi <@user>!')
    end
  end
end
