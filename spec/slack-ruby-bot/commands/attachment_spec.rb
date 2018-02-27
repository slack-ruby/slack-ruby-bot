describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      attachment(/New comment matched by pretext #(?<id>\d+)/) do |client, data, match|
        client.say(text: "The id: #{match[:id]}", channel: data.channel)
        client.say(text: "Comment: '#{data.attachments[0].text}'", channel: data.channel)
      end
      attachment(/New comment matched by text #(?<id>\d+)/) do |client, data, match|
        client.say(text: "The id: #{match[:id]}", channel: data.channel)
        client.say(text: "Comment: '#{data.attachments[0].title}'", channel: data.channel)
      end
      attachment(/New comment matched by title #(?<id>\d+)/) do |client, data, match|
        client.say(text: "The id: #{match[:id]}", channel: data.channel)
        client.say(text: "Comment: '#{data.attachments[0].pretext}'", channel: data.channel)
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end

  let :expected_responses do
    [
      'The id: 12345',
      "Comment: 'foo bar'"
    ]
  end
  it 'matches pretext' do
    attachment = {
      pretext: 'New comment matched by pretext #12345',
      text: 'foo bar'
    }
    expect(attachments: [attachment]).to respond_with_slack_messages(expected_responses)
  end
  it 'matches text' do
    attachment = {
      text: 'New comment matched by text #12345',
      title: 'foo bar'
    }
    expect(attachments: [attachment]).to respond_with_slack_messages(expected_responses)
  end
  it 'matches title' do
    attachment = {
      title: 'New comment matched by title #12345',
      pretext: 'foo bar'
    }
    expect(attachments: [attachment]).to respond_with_slack_messages(expected_responses)
  end
  it 'does not respond' do
    attachment = {
      text: 'no match'
    }
    expect(attachments: [attachment]).to not_respond
  end
end
