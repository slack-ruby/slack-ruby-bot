# frozen_string_literal: true

describe SlackRubyBot do
  def client
    SlackRubyBot::Client.new aliases: %w[:emoji: alias каспаров B0?.@(*^$]
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
  it 'responds to an alias with special characters' do
    expect(message: 'B0?.@(*^$ hi').to respond_with_slack_message('Hi <@user>!')
  end
end
