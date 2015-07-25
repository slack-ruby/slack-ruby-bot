require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'empty_text'

      def self.call(client, data, _match)
        send_message client, data.channel, nil
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  let(:client) { app.send(:client) }
  it 'sends default text' do
    allow(Giphy).to receive(:random)
    expect(SlackRubyBot::Commands::Base).to receive(:send_message_with_gif).with(client, 'channel', 'Nothing to see here.', 'nothing', {})
    app.send(:message, client, text: "#{SlackRubyBot.config.user} empty_text", channel: 'channel', user: 'user')
  end
end
