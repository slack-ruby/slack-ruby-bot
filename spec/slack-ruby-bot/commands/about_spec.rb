# frozen_string_literal: true

describe SlackRubyBot::Commands::Default do
  it 'lowercase' do
    expect(message: SlackRubyBot.config.user).to respond_with_slack_message(SlackRubyBot::ABOUT)
  end
  it 'upcase' do
    expect(message: SlackRubyBot.config.user.upcase).to respond_with_slack_message(SlackRubyBot::ABOUT)
  end
  it 'name:' do
    expect(message: "#{SlackRubyBot.config.user}:").to respond_with_slack_message(SlackRubyBot::ABOUT)
  end
  it 'id' do
    expect(message: "<@#{SlackRubyBot.config.user_id}>").to respond_with_slack_message(SlackRubyBot::ABOUT)
  end
end
