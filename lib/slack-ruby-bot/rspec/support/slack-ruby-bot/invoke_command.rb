require 'rspec/expectations'

RSpec::Matchers.define :invoke_command do |expected|
  match do |actual|
    client = if respond_to?(:client)
               send(:client)
             else
               SlackRubyBot::Client.new
             end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message = parse(actual)

    expect(client).to receive(:message).with(channel: channel, text: expected)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
    true
  end

  private

  def parse(actual)
    unless actual.is_a?(Hash)
      actual = { message: actual }
      channel = 'channel'
      user = parse_user(actual)
    end
    [actual[:channel] || channel, actual[:user] || user || parse_user(actual[:message]) || 'WRONG', actual[:message]]
  end

  def parse_user(actual)
    actual.split(' ').first
  end
end

RSpec::Matchers.define :not_invoke_command do |expected|
  match do |actual|
    client = if respond_to?(:client)
               send(:client)
             else
               SlackRubyBot::Client.new
             end

    message_command = SlackRubyBot::Hooks::Message.new
    channel, user, message = parse(actual)

    expect(client).not_to receive(:message).with(channel: channel, text: expected)
    message_command.call(client, Hashie::Mash.new(text: message, channel: channel, user: user))
    true
  end

  private

  def parse(actual)
    unless actual.is_a?(Hash)
      actual = { message: actual }
      channel = 'channel'
      user = parse_user(actual)
    end
    [actual[:channel] || channel, actual[:user] || user || parse_user(actual[:message]) || 'WRONG', actual[:message]]
  end

  def parse_user(actual)
    actual.split(' ').first
  end
end
