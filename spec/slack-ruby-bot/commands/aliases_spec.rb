require 'spec_helper'

describe SlackRubyBot do
  def app
    SlackRubyBot::App.new
  end
  before do
    ENV['SLACK_RUBY_BOT_ALIASES'] = ':emoji: alias каспаров'
  end
  after do
    ENV.delete('SLACK_RUBY_BOT_ALIASES')
  end
  it 'responds to emoji' do
    expect(message: ':emoji: hi').to respond_with_slack_message('Hi <@user>!')
  end
  it 'responds to an alias' do
    expect(message: 'alias hi').to respond_with_slack_message('Hi <@user>!')
  end
  it 'responds to a non-English alias' do
    expect(message: 'каспаров hi').to respond_with_slack_message('Hi <@user>!')
  end
end
