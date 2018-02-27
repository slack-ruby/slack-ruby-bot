require 'rspec/expectations'
RSpec::Matchers.define :respond_with_slack_message do |expected|
  include SlackRubyBot::SpecHelpers
  match do |actual|
    client = respond_to?(:client) ? send(:client) : SlackRubyBot::Client.new
    def client.test_messages
      @test_received_messages
    end

    def client.say(options = {})
      super
      @test_received_messages = @test_received_messages.nil? ? [] : @test_received_messages
      @test_received_messages.push options
    end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message, attachments = parse(actual)

    allow(Giphy).to receive(:random) if defined?(Giphy)

    allow(client).to receive(:message)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user, attachments: attachments))
    @messages = client.test_messages
    expect(client).to have_received(:message).with(hash_including(channel: channel, text: expected)).once
    true
  end

  failure_message do |_actual|
    message = "expected to receive message with text: #{expected} once,\n received:"
    message += @messages.count.zero? ? 'No response messages received' : @messages.inspect
    message
  end
end
