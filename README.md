Slack-Ruby-Bot
==============

[![Gem Version](https://badge.fury.io/rb/slack-ruby-bot.svg)](http://badge.fury.io/rb/slack-ruby-bot)
[![Build Status](https://travis-ci.org/dblock/slack-ruby-bot.png)](https://travis-ci.org/dblock/slack-ruby-bot)

A generic Slack bot framework written in Ruby on top of [slack-ruby-client](https://github.com/dblock/slack-ruby-client). This library does all the heavy lifting, such as message parsing, so you can focus on implementing slack bot commands. It also attempts to itroduce the bare minimum number of requirements or any sorts of limitations. It's a Slack bot boilerplate.

## Usage

### A Minimal Bot

#### Gemfile

```ruby
source 'http://rubygems.org'

gem 'slack-ruby-bot'
```

#### pongbot.rb

```ruby
require 'slack-ruby-bot'

module PongBot
  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    command 'ping' do |client, data, _match|
      client.message text: 'pong', channel: data.channel
    end
  end
end

PongBot::App.instance.run
```

After [registering the bot](DEPLOYMENT.md), run with `SLACK_API_TOKEN=... bundle exec ruby pongbot.rb`. Have the bot join a channel and send it a ping.

![](screenshots/demo.gif)

### A Production Bot

A typical production Slack bot is a combination of a vanilla web server and a websocket application that talks to the Slack Real Time Messaging API. See our [Writing a Production Bot](TUTORIAL.md) tutorial for more information.

### More Involved Examples

The following examples of production-grade bots based on slack-ruby-bot are listed in growing order of complexity.

* [slack-mathbot](https://github.com/dblock/slack-mathbot): Slack integration with math.
* [slack-google-bot](https://github.com/dblock/slack-google-bot): A Slack bot that searches Google, including CSE.
* [slack-aws](https://github.com/dblock/slack-aws): Slack integration with Amazon Web Services.
* [slack-gamebot](https://github.com/dblock/slack-gamebot): A generic game bot for ping-pong, chess, etc.

### Commands and Operators

Bots are addressed by name and respond to commands and operators. By default a command class responds, case-insensitively, to its name. A class called `Phone` that inherits from `SlackRubyBot::Commands::Base` responds to `phone` and `Phone` and calls the `call` method when implemented.

```ruby
class Phone < SlackRubyBot::Commands::Base
  command 'call'

  def self.call(client, data, _match)
    send_message client, data.channel, 'called'
  end
end
```

To respond to custom commands and to disable automatic class name matching, use the `command` keyword. The following command responds to `call` and `呼び出し` (call in Japanese).

```ruby
class Phone < SlackRubyBot::Commands::Base
  command 'call'
  command '呼び出し'

  def self.call(client, data, _match)
    send_message client, data.channel, 'called'
  end
end
```

You can combine multiple commands and use a block to implement them.

```ruby
class Phone < SlackRubyBot::Commands::Base
  command 'call', '呼び出し' do |client, data, _match|
    send_message client, data.channel, 'called'
  end
end
```

Command match data includes `match['bot']`, `match['command']` and `match['expression']`. The `bot` match always checks against the `SlackRubyBot::Config.user` and `SlackRubyBot::Config.user_id` values obtained when the bot starts.

Operators are 1-letter long and are similar to commands. They don't require addressing a bot nor separating an operator from its arguments. The following class responds to `=2+2`.

```ruby
class Calculator < SlackRubyBot::Commands::Base
  operator '=' do |_data, _match|
    # implementation detail
  end
end
```

Operator match data includes `match['operator']` and `match['expression']`. The `bot` match always checks against the `SlackRubyBot::Config.user` setting.

### Bot Aliases

A bot will always respond to its name (eg. `rubybot`) and Slack ID (eg. `@rubybot`), but you can specify multiple aliases via the `SLACK_RUBY_BOT_ALIASES` environment variable or via an explicit configuration.

```
SLACK_RUBY_BOT_ALIASES=:pp: table-tennis
```

```ruby
SlackRubyBot.configure do |config|
  config.aliases = [':pong:', 'pongbot']
end
```

This is particularly fun with emoji.

![](screenshots/aliases.gif)

Bots also will respond to a direct message, with or without the bot name in the message itself.

![](screenshots/dms.gif)

### Generic Routing

Commands and operators are generic versions of bot routes. You can respond to just about anything by defining a custom route.

```ruby
class Weather < SlackRubyBot::Commands::Base
  match /^How is the weather in (?<location>\w*)\?$/ do |client, data, match|
    send_message client, data.channel, "The weather in #{match[:location]} is nice."
  end
end
```

![](screenshots/weather.gif)

### SlackRubyBot::Commands::Base Functions

#### send_message(client, channel, text)

Send text using a RealTime client to a channel.

#### send_message_with_gif(client, channel, text, keyword)

Send text along with a random animated GIF based on a keyword.

### Built-In Commands

Slack-ruby-bot comes with several built-in commands. You can re-define built-in commands, normally, as described above.

#### [bot name]

This is also known as the `default` command. Shows bot version and links.

#### [bot name] hi

Politely says 'hi' back.

#### [bot name] help

Get help.

### RSpec Shared Behaviors

Slack-ruby-bot ships with a number of shared RSpec behaviors that can be used in your RSpec tests. Require 'slack-ruby-bot/rspec' in your `spec_helper.rb`.

* [behaves like a slack bot](lib/slack-ruby-bot/rspec/support/slack-ruby-bot/it_behaves_like_a_slack_bot.rb): A bot quacks like a Slack Ruby bot.
* [respond with slack message](lib/slack-ruby-bot/rspec/support/slack-ruby-bot/respond_with_slack_message.rb): The bot responds with a message.
* [respond with error](lib/slack-ruby-bot/rspec/support/slack-ruby-bot/respond_with_error.rb): An exception is raised inside a bot command.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Upgrading

See [CHANGELOG](CHANGELOG.md) for a history of changes and [UPGRADING](UPGRADING.md) for how to upgrade to more recent versions.

## Copyright and License

Copyright (c) 2015, [Daniel Doubrovkine](https://twitter.com/dblockdotorg), [Artsy](https://www.artsy.net) and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
