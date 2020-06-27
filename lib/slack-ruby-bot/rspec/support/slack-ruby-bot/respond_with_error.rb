# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :respond_with_error do |error, error_message|
  match do |actual|
    client = respond_to?(:client) ? send(:client) : SlackRubyBot::Client.new

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message, attachments = parse(actual)

    begin
      expect do
        message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user, attachments: attachments))
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
    attachments = actual[:attachments]
    attachments = [attachments] unless attachments.nil? || attachments.is_a?(Array)
    [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message], attachments]
  end
end
