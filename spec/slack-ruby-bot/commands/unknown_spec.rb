# frozen_string_literal: true

describe SlackRubyBot::Commands::Unknown do
  it 'invalid command' do
    expect(message: "#{SlackRubyBot.config.user} foobar").to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end
  it 'invalid command with @bot:' do
    expect(message: "<@#{SlackRubyBot.config.user_id}>: foobar").to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end
  it 'does not respond to sad face' do
    client = SlackRubyBot::Client.new
    message_hook = SlackRubyBot::Hooks::Message.new

    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message)
    message_hook.call(client, Hashie::Mash.new(text: ':((', channel: 'channel', user: 'user'))
  end
end
