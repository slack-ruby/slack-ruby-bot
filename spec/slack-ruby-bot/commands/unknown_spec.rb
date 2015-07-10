require 'spec_helper'

describe SlackRubyBot::Commands::Unknown do
  def app
    SlackRubyBot::App.new
  end
  it 'invalid command' do
    expect(message: "#{SlackRubyBot.config.user} foobar").to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end
  it 'does not respond to sad face' do
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message)
    SlackRubyBot::App.new.send(:message, text: ':((')
  end
end
