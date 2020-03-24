# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'space' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'matches leading spaces' do
    expect(message: "  #{SlackRubyBot.config.user}   space red").to respond_with_slack_message('space: red')
  end
  it 'matches trailing spaces' do
    expect(message: "#{SlackRubyBot.config.user}   space    red   ").to respond_with_slack_message('space: red')
  end
end
