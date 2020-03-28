# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'tomato' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end

      command 'tomatoes' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'matches commands' do
    expect(message: "#{SlackRubyBot.config.user} tomato red").to respond_with_slack_message('tomato: red')
    expect(message: "#{SlackRubyBot.config.user} tomatoes green").to respond_with_slack_message('tomatoes: green')
  end
end
