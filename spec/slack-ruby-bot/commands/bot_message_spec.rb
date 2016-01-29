require 'spec_helper'

describe SlackRubyBot::Commands::Help do
  def app
    SlackRubyBot::App.new
  end
  it 'bot' do
    expect(message: "#{SlackRubyBot.config.user} bot").to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end
end
