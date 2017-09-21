require 'rspec/expectations'
RSpec::Matchers.define :respond_with_slack_messages do |expected|
  include SlackRubyBot::SpecHelpers
  match do |actual|
    raise ArgumentError, 'respond_with_slack_messages expects an array of ordered responses' unless expected.respond_to? :each
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
    channel, user, message = parse(actual)

    allow(Giphy).to receive(:random) if defined?(Giphy)

    allow(client).to receive(:message)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
    @messages = client.test_messages
    @responses = []
    expected.each do |exp|
      @responses.push(expect(client).to(have_received(:message).with(hash_including(channel: channel, text: exp)).once))
    end
    true
  end
  failure_message do |_actual|
    message = ''
    expected.each do |exp|
      message += "Expected text: #{exp}, got #{@messages[expected.index(exp)] || 'No Response'}\n" unless @responses[expected.index(exp)]
    end
    message
  end
end
