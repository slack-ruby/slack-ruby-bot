require 'spec_helper'

describe SlackRubyBot::Commands::Help do
  def app
    SlackRubyBot::App.new
  end
  before do
    app.config.user = 'rubybot'
  end
  it 'help' do
    expect(message: 'rubybot help').to respond_with_slack_message('See https://github.com/dblock/slack-ruby-bot, please.')
  end
end
