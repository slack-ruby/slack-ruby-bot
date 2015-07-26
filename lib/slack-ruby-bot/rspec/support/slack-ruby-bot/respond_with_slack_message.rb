require 'rspec/expectations'

RSpec::Matchers.define :respond_with_slack_message do |expected|
  match do |actual|
    channel, user, message = parse(actual)
    allow(Giphy).to receive(:random)
    client = app.send(:client)
    expect(SlackRubyBot::Commands::Base).to receive(:send_client_message).with(client, channel: channel, text: expected)
    app.send(:message, client, text: message, channel: channel, user: user)
    true
  end

  private

  def parse(actual)
    actual = { message: actual } unless actual.is_a?(Hash)
    [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message]]
  end
end
