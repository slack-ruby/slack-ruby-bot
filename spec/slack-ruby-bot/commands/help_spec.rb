# frozen_string_literal: true

describe SlackRubyBot::Commands::Help do
  def app
    SlackRubyBot::App.new
  end
  it 'help' do
    message = <<~MSG
      *Weather Bot* - This bot tells you the weather.

      *Commands:*
      *clouds* - Tells you how many clouds there're above you.
      *command_without_description*
      *What's the weather in <city>?* - Tells you the weather in a <city>.

      *Other commands:*
      *help* - Shows help information.
      *hi* - Says hello.
      *hello* - Says hello.

      For getting description of the command use: *help <command>*

      For more information see https://github.com/slack-ruby/slack-ruby-bot, please.
    MSG

    expect(message: "#{SlackRubyBot.config.user} help").to respond_with_slack_message(message)
  end
end
