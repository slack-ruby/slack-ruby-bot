describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
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
  it 'respond_with_multiple_messages_using_string_matches_with_extra_arg' do
    expected_responses = []
    5.times { |i| expected_responses.push("response #{i}") }
    expect(message: "#{SlackRubyBot.config.user} respond with as_user")
      .to respond_with_slack_messages(expected_responses)
  end
end
