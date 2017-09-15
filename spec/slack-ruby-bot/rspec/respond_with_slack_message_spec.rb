describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'single message' do |client, data, _match|
        client.say(text: 'single response', channel: data.channel)
      end
      command 'respond 5 times' do |client, data, _match|
        5.times do |i|
          client.say(text: "response #{i}", channel: data.channel)
        end
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
  it 'respond_with_single_message_using_string_match' do
    expect(message: "#{SlackRubyBot.config.user} single message")
      .to respond_with_slack_message('single response')
  end
  it 'respond_with_multiple_messages_looking_for_single_match' do
    expect(message: "#{SlackRubyBot.config.user} respond 5 times")
      .to respond_with_slack_message('response 1')
  end
end
