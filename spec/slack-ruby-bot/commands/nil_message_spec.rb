# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'nil_text'

      def self.call(_client, data, _match)
        send_message client, data.channel, nil
      end
    end
  end

  let(:app) { SlackRubyBot::App.new }
  let(:client) { app.send(:client) }
  let(:message_hook) { SlackRubyBot::Hooks::Message.new }

  it 'ignores nil messages' do
    expect(client).to_not receive(:message)
    message_hook.call(client, Hashie::Mash.new(text: nil, channel: 'channel', user: 'user'))
  end
end
