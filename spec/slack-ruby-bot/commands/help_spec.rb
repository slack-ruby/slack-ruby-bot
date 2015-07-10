require 'spec_helper'

describe SlackRubyBot::Commands::Help do
  def app
    SlackRubyBot::App.new
  end
  it 'help' do
    expect(message: "#{SlackRubyBot.config.user} help").to respond_with_slack_message('See https://github.com/dblock/slack-ruby-bot, please.')
  end
end
