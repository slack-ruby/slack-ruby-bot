# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'set' do |client, data, match|
        if match['expression']
          k, v = match['expression'].split(/\W+/, 2)
          client.say(channel: data.channel, text: "#{match[:command]}: #{k}=#{v}")
        else
          client.say(channel: data.channel, text: (match[:command]).to_s)
        end
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'parses expression' do
    expect(message: "#{SlackRubyBot.config.user} set").to respond_with_slack_message('set')
    expect(message: "#{SlackRubyBot.config.user} set x").to respond_with_slack_message('set: x=')
    expect(message: "#{SlackRubyBot.config.user} set x y").to respond_with_slack_message('set: x=y')
  end
end
