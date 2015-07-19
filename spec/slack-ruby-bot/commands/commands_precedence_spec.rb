require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'tomato' do |data, match|
        send_message data.channel, "#{match[:command]}: #{match[:expression]}", as_user: true
      end

      command 'tomatoes' do |data, match|
        send_message data.channel, "#{match[:command]}: #{match[:expression]}", as_user: true
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
