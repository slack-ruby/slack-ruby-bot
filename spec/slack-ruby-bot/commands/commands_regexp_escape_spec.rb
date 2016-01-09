require 'spec_helper'

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
end
