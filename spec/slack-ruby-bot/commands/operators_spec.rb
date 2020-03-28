# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      operator '='
      operator '-'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "#{match[:operator]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'supports operators' do
    expect(message: '=2+2').to respond_with_slack_message('=: 2+2')
  end
end
