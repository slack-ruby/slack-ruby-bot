require 'slack-ruby-bot'

module WeatherBot
  class App < SlackRubyBot::App
  end

  class Weather < SlackRubyBot::Commands::Base
    match(/^How is the weather in (?<location>\w*)\?$/i) do |data, match|
      send_message data.channel, "The weather in #{match[:location]} is nice."
    end
  end
end

WeatherBot::App.instance.run
