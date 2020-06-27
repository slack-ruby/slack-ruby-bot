# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :respond_with_slack_messages do |expected|
  include SlackRubyBot::SpecHelpers

  match do |actual|
    raise ArgumentError, 'respond_with_slack_messages expects an array of ordered responses' if expected && !expected.respond_to?(:each)

    client = respond_to?(:client) ? send(:client) : SlackRubyBot::Client.new

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message, attachments = parse(actual)

    @messages ||= []
    allow(client).to receive(:message) do |options|
      @messages.push options
    end

    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user, attachments: attachments))

    @responses = []

    if expected&.any?
      expected.each do |exp|
        @responses.push(expect(client).to(have_received(:message).with(hash_including(channel: channel, text: exp)).once))
      end
    else
      expect(@messages.size).to be > 1
    end

    true
  end

  failure_message do |_actual|
    if expected&.any?
      expected.map do |exp|
        "Expected text: #{exp}, got #{@messages[expected.index(exp)] || 'none'}" unless @responses[expected.index(exp)]
      end.compact.join("\n")
    else
      "Expected to receive multiple messages, got #{@messages.any? ? @messages.size : 'none'}"
    end
  end
end
