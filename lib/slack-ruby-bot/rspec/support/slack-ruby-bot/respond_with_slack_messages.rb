require 'rspec/expectations'
RSpec::Matchers.define :respond_with_slack_messages do |expected|
  match do |actual|
    raise ArgumentError, 'respond_with_slack_messages expects an array of ordered responses' unless expected.is_a? Array
    client = if respond_to?(:client)
               send(:client)
             else
               SlackRubyBot::Client.new
             end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message = parse(actual)

    allow(Giphy).to receive(:random) if defined?(Giphy)

    allow(client).to receive(:message)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
    expected.each do |exp|
      expect(client).to have_received(:message).with(channel: channel, text: exp).once
    end
    true
  end

private

  def parse(actual)
    actual = { message: actual } unless actual.is_a?(Hash)
    [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message]]
  end
end
