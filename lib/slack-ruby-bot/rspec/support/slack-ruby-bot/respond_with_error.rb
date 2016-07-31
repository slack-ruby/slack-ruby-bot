require 'rspec/expectations'

RSpec::Matchers.define :respond_with_error do |error, error_message|
  match do |actual|
    client = if respond_to?(:client)
               send(:client)
             else
               SlackRubyBot::Client.new
             end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message = parse(actual)

    allow(Giphy).to receive(:random) if defined?(Giphy)

    begin
      expect do
        message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
      end.to raise_error error, error_message
    rescue RSpec::Expectations::ExpectationNotMetError => e
      @error_message = e.message
      raise e
    end
    true
  end

  failure_message do |actual|
    _, _, message = parse(actual)
    @error_message || "expected for '#{message}' to fail with '#{expected}'"
  end

  private

  def parse(actual)
    actual = { message: actual } unless actual.is_a?(Hash)
    [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message]]
  end
end
