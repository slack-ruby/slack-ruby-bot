require 'rspec/expectations'

RSpec::Matchers.define :not_respond do
  match do |actual|
    client = if respond_to?(:client)
               send(:client)
             else
               SlackRubyBot::Client.new
             end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message = parse(actual)

    expect(client).not_to receive(:message)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
    true
  end

  private

  def parse(actual)
    actual = { message: actual } unless actual.is_a?(Hash)
    [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message]]
  end
end
