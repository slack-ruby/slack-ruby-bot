# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :not_respond do
  match do |actual|
    client = respond_to?(:client) ? send(:client) : SlackRubyBot::Client.new

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message, attachments = parse(actual)

    expect(client).not_to receive(:message)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user, attachments: attachments))
    true
  end

  private

  def parse(actual)
    actual = { message: actual } unless actual.is_a?(Hash)
    attachments = actual[:attachments]
    attachments = [attachments] unless attachments.nil? || attachments.is_a?(Array)
    [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message], attachments]
  end
end
