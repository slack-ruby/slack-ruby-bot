# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      operator '=' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:operator]}: #{match[:expression]}")
      end

      operator '+', '-' do |client, data, match|
        client.say(channel: data.channel, text: "#{match[:operator]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'supports operator blocks' do
    expect(message: '=2+2').to respond_with_slack_message('=: 2+2')
    expect(message: '+2+2').to respond_with_slack_message('+: 2+2')
    expect(message: '-2+2').to respond_with_slack_message('-: 2+2')
  end
end
