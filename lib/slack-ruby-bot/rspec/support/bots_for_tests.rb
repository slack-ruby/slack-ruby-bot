# frozen_string_literal: true

module Testing
  class WeatherBot < SlackRubyBot::Bot
    help do
      title 'Weather Bot'
      desc 'This bot tells you the weather.'

      command 'clouds' do
        desc 'Tells you how many clouds there\'re above you.'
      end

      command '' do
        desc 'empty description'
      end

      command 'command_without_description' do
      end

      command 'What\'s the weather in <city>?' do
        desc 'Tells you the weather in a <city>.'
        long_desc "Accurate 10 Day Weather Forecasts for thousands of places around the World.\n" \
          'We provide detailed Weather Forecasts over a 10 day period updated four times a day.'
      end
    end
  end

  class HelloCommand < SlackRubyBot::Commands::Base
    help do
      title 'hello'
      desc 'Says hello.'
      long_desc 'The long description'
    end
  end
end
