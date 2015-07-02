require 'spec_helper'

describe SlackRubyBot::Commands::Unknown, vcr: { cassette_name: 'user_info' } do
  def app
    SlackRubyBot::App.new
  end
  before do
    app.config.user = 'rubybot'
  end
  it 'invalid command' do
    expect(message: 'rubybot foobar').to respond_with_slack_message("Sorry <@user>, I don't understand that command!")
  end
  it 'does not respond to sad face' do
    expect(SlackRubyBot::Commands::Base).to_not receive(:send_message)
    SlackRubyBot::App.new.send(:message, text: ':((')
  end
end
