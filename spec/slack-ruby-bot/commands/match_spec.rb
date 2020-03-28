# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      match(/^Reticulate (?<spline_name>\w*)$/) do |client, data, match|
        client.say(channel: data.channel, text: "Reticulated #{match[:spline_name]}.")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'matches' do
    expect(message: 'Reticulate spline').to respond_with_slack_message('Reticulated spline.')
  end
end
