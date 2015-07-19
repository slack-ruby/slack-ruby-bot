require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'empty_text'

      def self.call(data, _command, _arguments)
        send_message data.channel, nil
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'sends default text' do
    allow(Giphy).to receive(:random)
    expect(SlackRubyBot::Commands::Base).to receive(:send_message_with_gif).with('channel', 'Nothing to see here.', 'nothing', as_user: true)
    app.send(:message, text: "#{SlackRubyBot.config.user} empty_text", channel: 'channel', user: 'user')
  end
end
