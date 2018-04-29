# frozen_string_literal: true

describe SlackRubyBot::Commands::Hi do
  def app
    SlackRubyBot::App.new
  end
  it 'says hi' do
    expect(message: "#{SlackRubyBot.config.user} hi").to respond_with_slack_message('Hi <@user>!')
  end
  it 'says hi to bot:' do
    expect(message: "#{SlackRubyBot.config.user}: hi").to respond_with_slack_message('Hi <@user>!')
  end
  it 'says hi to @bot' do
    expect(message: "<@#{SlackRubyBot.config.user_id}> hi").to respond_with_slack_message('Hi <@user>!')
  end
  it 'says hi to @bot: ' do
    expect(message: "<@#{SlackRubyBot.config.user_id}>: hi").to respond_with_slack_message('Hi <@user>!')
  end
end
