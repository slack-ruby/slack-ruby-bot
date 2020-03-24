# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command '(' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  def app
    SlackRubyBot::App.new
  end

  it 'does not return error' do
    expect(message: "#{SlackRubyBot.config.user} ( /").to respond_with_slack_message('(: /')
  end

  it 'allows multiline expression' do
    expect(message: "#{SlackRubyBot.config.user} (\n1\n2").to respond_with_slack_message("(: 1\n2")
  end
end
