# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command(/some\s*regex+\?*/) do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'handles regular expressions' do
    expect(message: "#{SlackRubyBot.config.user} some regex works here").to respond_with_slack_message('some regex: works here')
    expect(message: "#{SlackRubyBot.config.user} some   RegEx?? yep").to respond_with_slack_message('some   RegEx??: yep')
  end
end
