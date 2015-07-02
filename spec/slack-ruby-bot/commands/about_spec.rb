require 'spec_helper'

describe SlackRubyBot::Commands::Default do
  def app
    SlackRubyBot::App.new
  end
  before do
    app.config.user = 'rubybot'
  end
  it 'rubybot' do
    expect(message: 'rubybot').to respond_with_slack_message(SlackRubyBot::ABOUT)
  end
  it 'Rubybot' do
    expect(message: 'Rubybot').to respond_with_slack_message(SlackRubyBot::ABOUT)
  end
end
