require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      operator '='
      operator '-'

      def self.call(data, match)
        send_message data.channel, "#{match[:operator]}: #{match[:expression]}", as_user: true
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
