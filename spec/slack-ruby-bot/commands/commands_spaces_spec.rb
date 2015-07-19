require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'space' do |data, match|
        send_message data.channel, "#{match[:command]}: #{match[:expression]}", as_user: true
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
