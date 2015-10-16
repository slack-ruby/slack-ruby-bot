require 'spec_helper'

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  let(:client) { subject.send(:client) }
  before do
    allow(client).to receive(:self).and_return('id' => 'UDEADBEEF')
    allow(Giphy).to receive(:random)
  end
  context 'default' do
    it 'does not respond to self' do
      expect(SlackRubyBot::Commands::Base).to_not receive(:send_client_message)
      subject.send(:message, client, text: "#{SlackRubyBot.config.user} hi", channel: 'channel', user: 'UDEADBEEF')
    end
  end
  context 'with allow_message_loops=true' do
    before do
      SlackRubyBot.configure do |config|
        config.allow_message_loops = true
      end
    end
    after do
      SlackRubyBot.configure do |config|
        config.allow_message_loops = nil
      end
    end
    it 'responds to self' do
      expect(SlackRubyBot::Commands::Base).to receive(:send_client_message)
      subject.send(:message, client, text: "#{SlackRubyBot.config.user} hi", channel: 'channel', user: 'UDEADBEEF')
    end
  end
end
