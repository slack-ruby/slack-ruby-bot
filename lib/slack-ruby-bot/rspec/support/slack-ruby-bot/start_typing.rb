# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :start_typing do |expected|
  include SlackRubyBot::SpecHelpers

  match do |actual|
    client = respond_to?(:client) ? send(:client) : SlackRubyBot::Client.new

    message_command = SlackRubyBot::Hooks::Message.new

    allow(client).to receive(:typing) do |options|
      @test_options = options
    end

    channel, user, message, attachments = parse(actual)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user, attachments: attachments))

    matcher = have_received(:typing).once
    matcher = matcher.with(expected) if expected&.any?
    expect(client).to matcher

    true
  end

  failure_message do |_actual|
    message = "expected to receive typing with: #{expected} once,\n received:"
    message += @test_options&.any? ? @test_options.inspect : ' none'
    message
  end
end
