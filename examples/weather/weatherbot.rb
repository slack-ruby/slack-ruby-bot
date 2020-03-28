# frozen_string_literal: true

require 'slack-ruby-bot'

SlackRubyBot::Client.logger.level = Logger::WARN

class WeatherBot < SlackRubyBot::Bot
  help do
    title 'Weather Bot'
    desc 'This bot tells you the weather.'

    command 'clouds' do
      desc 'Tells you how many clouds there\'re above you.'
    end

    command 'What\'s the weather in <city>?' do
      desc 'Tells you the weather in a <city>.'
      long_desc "Accurate 10 Day Weather Forecasts for thousands of places around the World.\n" \
        'We provide detailed Weather Forecasts over a 10 day period updated four times a day.'
    end
  end

  match(/^How is the weather in (?<location>\w*)\?$/i) do |client, data, match|
    client.say(channel: data.channel, text: "The weather in #{match[:location]} is nice.")
  end
end

WeatherBot.run
