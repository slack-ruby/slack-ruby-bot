require 'spec_helper'

describe SlackRubyBot::Commands::Hi do
  def app
    SlackRubyBot::App.new
  end
  before do
    app.config.user = 'rubybot'
  end
  it 'says hi' do
    expect(message: 'rubybot hi').to respond_with_slack_message('Hi <@user>!')
  end
end
