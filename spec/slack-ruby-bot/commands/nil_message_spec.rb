require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'nil_text'

      def self.call(_client, data, _match)
        send_message cilent, data.channel, nil
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  let(:client) { app.send(:client) }
  it 'ignores nil messages' do
    allow(Giphy).to receive(:random)
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message_with_gif)
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_gif)
    app.send(:message, client, text: nil, channel: 'channel', user: 'user')
  end
end
