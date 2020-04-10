# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'non_breaking_space' do |client, data, match|
        client.say(channel: data.channel, text: match['expression'])
      end
    end
  end
  it 'sends a message with non-breaking space after bot name' do
    expect(message: "#{SlackRubyBot.config.user}\u00a0non_breaking_space message").to respond_with_slack_message('message')
  end
  it 'sends a message with non-breaking space after command' do
    expect(message: "#{SlackRubyBot.config.user} non_breaking_space\u00a0message").to respond_with_slack_message('message')
  end
  it 'sends a message with all non-breaking spaces' do
    expect(message: "#{SlackRubyBot.config.user}\u00a0non_breaking_space\u00a0message").to respond_with_slack_message('message')
  end
  it 'sends a message with trailing non-breaking spaces' do
    expect(message: "#{SlackRubyBot.config.user} non_breaking_space message\u00a0").to respond_with_slack_message("message\u00a0")
  end
  it 'sends a message with multiple non-breaking spaces' do
    expect(message: "#{SlackRubyBot.config.user} non_breaking_space message1\u00a0message2").to respond_with_slack_message("message1\u00a0message2")
  end
  it 'sends a message with non-breaking spaces on multiple lines' do
    expect(message: "#{SlackRubyBot.config.user} non_breaking_space message1\u00a0message2\nmessage3\u00a0message4").to respond_with_slack_message("message1\u00a0message2\nmessage3\u00a0message4")
  end
end
