# frozen_string_literal: true

describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'types on the correct channel' do |client, data, _match|
        client.typing(channel: data.channel)
      end
      command 'types on another channel' do |client, _data, _match|
        client.typing(channel: 'another')
      end
    end
  end

  def app
    SlackRubyBot::App.new
  end
  it 'types on any channel' do
    expect(message: "#{SlackRubyBot.config.user} types on the correct channel", channel: 'channel')
      .to start_typing
  end
  it 'types on another channel' do
    expect(message: "#{SlackRubyBot.config.user} types on another channel", channel: 'channel')
      .to start_typing(channel: 'another')
  end
  it 'types an invalid channel' do
    expect(message: "#{SlackRubyBot.config.user} types on another channel", channel: 'channel')
      .to_not start_typing(channel: 'invalid')
  end
  it 'correctly reports error' do
    expect do
      expect(message: "#{SlackRubyBot.config.user} types on another channel", channel: 'channel')
        .to start_typing(channel: 'invalid')
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, "expected to receive typing with: {:channel=>\"invalid\"} once,\n received:{:channel=>\"another\"}"
  end
end
