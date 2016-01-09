require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'sayhi'
      command 'saybye'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'supports multiple commands' do
    expect(message: "#{SlackRubyBot.config.user} sayhi arg1 arg2").to respond_with_slack_message('sayhi: arg1 arg2')
    expect(message: "#{SlackRubyBot.config.user} saybye arg1 arg2").to respond_with_slack_message('saybye: arg1 arg2')
  end
end
