describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
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
end
