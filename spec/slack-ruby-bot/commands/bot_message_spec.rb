# frozen_string_literal: true

describe SlackRubyBot::Commands::Unknown do
  def app
    SlackRubyBot::App.new
  end
  it 'bot' do
    expect(message: "#{SlackRubyBot.config.user} bot").to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end
end
