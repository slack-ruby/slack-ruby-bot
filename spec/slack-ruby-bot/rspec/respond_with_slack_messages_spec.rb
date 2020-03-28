# frozen_string_literal: true

describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'do not respond' do |client, data, _match|
      end
      command 'respond once' do |client, data, _match|
        client.say(text: 'response', channel: data.channel, as_user: true)
      end
      command 'respond with as_user' do |client, data, _match|
        5.times do |i|
          client.say(text: "response #{i}", channel: data.channel, as_user: true)
        end
      end
      command 'respond 5 times' do |client, data, _match|
        5.times do |i|
          client.say(text: "response #{i}", channel: data.channel)
        end
      end
      attachment 'respond with attachment title' do |client, data, _match|
        data[:attachments].each do |attachment|
          client.say(text: "response #{attachment.title}", channel: data.channel)
        end
      end
    end
  end

  def app
    SlackRubyBot::App.new
  end

  it 'respond_with_multiple_messages_using_regex_matches' do
    expected_responses = []
    5.times { |i| expected_responses.push(/response #{i}/i) }
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .to respond_with_slack_messages(expected_responses)
  end
  it 'respond with multiple messages' do
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .to respond_with_slack_messages
  end
  it 'respond once' do
    expect do
      expect(message: "#{SlackRubyBot.config.user} respond once")
        .to respond_with_slack_messages
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, 'Expected to receive multiple messages, got 1'
  end
  it 'do not respond' do
    expect(message: "#{SlackRubyBot.config.user} do not respond")
      .to_not respond_with_slack_messages
  end
  it 'correctly reports error on do not respond' do
    expect do
      expect(message: "#{SlackRubyBot.config.user} do not respond")
        .to respond_with_slack_messages
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, 'Expected to receive multiple messages, got none'
  end
  it 'respond_with_multiple_messages_using_string_matches' do
    expected_responses = []
    5.times { |i| expected_responses.push("response #{i}") }
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .to respond_with_slack_messages(expected_responses)
  end
  it 'not_respond_with_multiple_messages_using_string_matches' do
    expected_responses = []
    6.times { |i| expected_responses.push("response #{i}") }
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .not_to respond_with_slack_messages(expected_responses)
  end
  it 'correctly reports error' do
    expect do
      expected_responses = []
      6.times { |i| expected_responses.push("response #{i}") }
      expect(message: "#{SlackRubyBot.config.user} respond 5 times")
        .to respond_with_slack_messages(expected_responses)
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, 'Expected text: response 5, got none'
  end

  it 'respond_with_multiple_messages_using_string_matches_with_extra_arg' do
    expected_responses = []
    5.times { |i| expected_responses.push("response #{i}") }
    expect(message: "#{SlackRubyBot.config.user} respond with as_user")
      .to respond_with_slack_messages(expected_responses)
  end
  it 'respond_with_multiple_messages_using_attachment_match' do
    attachments = []
    expected_responses = []
    5.times do |i|
      attachments.push(title: "title #{i}", pretext: 'respond with attachment title')
      expected_responses.push("response title #{i}")
    end
    expect(attachments: attachments)
      .to respond_with_slack_messages(expected_responses)
  end
end
