# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      scan(/(\$[A-Z]+)/) do |client, data, captures|
        client.say(channel: data.channel, text: "There were #{captures.count} captures: #{captures.join(', ')}.")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'captures' do
    expect(message: 'quote $YHOO and $MSFT').to respond_with_slack_message('There were 2 captures: $YHOO, $MSFT.')
  end
end
