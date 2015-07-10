require 'rspec/expectations'

RSpec::Matchers.define :respond_with_error do |expected|
  match do |actual|
    channel, user, message = parse(actual)
    app = SlackRubyBot::App.new
    allow(Giphy).to receive(:random)
    begin
      expect do
        app.send(:message, text: message, channel: channel, user: user)
      end.to raise_error ArgumentError, expected
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
