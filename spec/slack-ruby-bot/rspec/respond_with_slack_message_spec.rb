# frozen_string_literal: true

describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'no message' do |client, data, _match|
      end
      command 'single message with as_user' do |client, data, _match|
        client.say(text: 'single response', channel: data.channel, as_user: true)
      end
      command 'single message' do |client, data, _match|
        client.say(text: 'single response', channel: data.channel)
      end
      command 'respond 5 times' do |client, data, _match|
        5.times do |i|
          client.say(text: "response #{i}", channel: data.channel)
        end
      end
      attachment 'respond with attachment text' do |client, data, _match|
        client.say(text: data.attachments[0].text.to_s, channel: data.channel)
      end
    end
  end

  def app
    SlackRubyBot::App.new
  end
  it 'respond_with_single_message_using_regex_match' do
    expect(message: "#{SlackRubyBot.config.user} single message")
      .to respond_with_slack_message(/single response/i)
  end
  it 'respond with any message' do
    expect(message: "#{SlackRubyBot.config.user} single message")
      .to respond_with_slack_message
  end
  it 'correctly reports error' do
    expect do
      expect(message: "#{SlackRubyBot.config.user} single message")
        .to respond_with_slack_message('another response')
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, "expected to receive message with text: another response once,\n received:[{:text=>\"single response\", :channel=>\"channel\"}]"
  end
  it 'correctly reports error without message' do
    expect do
      expect(message: "#{SlackRubyBot.config.user} no message")
        .to respond_with_slack_message('another response')
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, "expected to receive message with text: another response once,\n received:none"
  end
  it 'respond_with_single_message_using_partial_regex_match' do
    expect(message: "#{SlackRubyBot.config.user} single message")
      .to respond_with_slack_message(/si[n|N]gle/)
  end
  it 'not_respond_with_single_message_using_bad_regex_match' do
    expect(message: "#{SlackRubyBot.config.user} single message")
      .not_to respond_with_slack_message(/si[g|G]gle/)
  end
  it 'respond_with_single_message_using_string_match' do
    expect(message: "#{SlackRubyBot.config.user} single message")
      .to respond_with_slack_message('single response')
  end
  it 'respond_with_single_message_using_regex_match_with_extra_args' do
    expect(message: "#{SlackRubyBot.config.user} single message with as_user")
      .to respond_with_slack_message(/single response/i)
  end
  it 'respond_with_multiple_messages_looking_for_single_match' do
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .to respond_with_slack_message('response 1')
  end
  it 'respond_with_multiple_messages_no_match' do
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .not_to respond_with_slack_message('response 7')
  end
  it 'respond_with_single_message_using_attachment_match' do
    attachment = {
      pretext: 'respond with attachment text',
      text: 'foobar'
    }
    expect(attachments: attachment)
      .to respond_with_slack_message('foobar')
  end
end
