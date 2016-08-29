Slack-Ruby-Bot
==============

[![Gem Version](https://badge.fury.io/rb/slack-ruby-bot.svg)](http://badge.fury.io/rb/slack-ruby-bot)
[![Build Status](https://travis-ci.org/slack-ruby/slack-ruby-bot.svg)](https://travis-ci.org/slack-ruby/slack-ruby-bot)
[![Code Climate](https://codeclimate.com/github/slack-ruby/slack-ruby-bot/badges/gpa.svg)](https://codeclimate.com/github/slack-ruby/slack-ruby-bot)

A generic Slack bot framework written in Ruby on top of [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client). This library does all the heavy lifting, such as message parsing, so you can focus on implementing slack bot commands. It also attempts to introduce the bare minimum number of requirements or any sorts of limitations. It's a Slack bot boilerplate.

If you are not familiar with Slack bots or Slack API concepts, you might want to watch [this video](http://code.dblock.org/2016/03/11/your-first-slack-bot-service-video.html).

![](slack.png)

## Useful to Me?

* If you are just trying to send messages to Slack, use [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client), which this library is built on top of.
* If you're trying to roll out a full service with Slack button integration, check out [slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server), which uses this library.
* Otherwise, this piece of the puzzle will help you create a single bot instance for one team.

## Stable Release

You're reading the documentation for the **next** release of slack-ruby-bot. Please see the documentation for the [last stable release, v0.9.0](https://github.com/slack-ruby/slack-ruby-bot/tree/v0.9.0) unless you're integrating with HEAD. See [CHANGELOG](CHANGELOG.md) for a history of changes and [UPGRADING](UPGRADING.md) for how to upgrade to more recent versions.

## Usage

### A Minimal Bot

#### Gemfile

```ruby
source 'https://rubygems.org'

gem 'slack-ruby-bot'
gem 'celluloid-io'
```

#### pongbot.rb

```ruby
require 'slack-ruby-bot'

class PongBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end
end

PongBot.run
```

After [registering the bot](DEPLOYMENT.md), run with `SLACK_API_TOKEN=... bundle exec ruby pongbot.rb`. Have the bot join a channel and send it a ping.

![](screenshots/demo.gif)

### A Production Bot

A typical production Slack bot is a combination of a vanilla web server and a websocket application that talks to the Slack Real Time Messaging API. See our [Writing a Production Bot](TUTORIAL.md) tutorial for more information.

### More Involved Examples

The following examples of bots based on slack-ruby-bot are listed in growing order of complexity.

* [slack-bot-on-rails](https://github.com/dblock/slack-bot-on-rails): A bot running on Rails and using React to display Slack messages on a website.
* [slack-mathbot](https://github.com/dblock/slack-mathbot): Slack integration with math.
* [slack-google-bot](https://github.com/dblock/slack-google-bot): A Slack bot that searches Google, including CSE.
* [slack-aws](https://github.com/dblock/slack-aws): Slack integration with Amazon Web Services.
* [slack-gamebot](https://github.com/dblock/slack-gamebot): A game bot service for ping pong, chess, etc, hosted at [playplay.io](http://playplay.io).

### Commands and Operators

Bots are addressed by name, they respond to commands and operators. You can combine multiple commands.

```ruby
class CallBot < SlackRubyBot::Bot
  command 'call', '呼び出し' do |client, data, match|
    client.say(channel: data.channel, text: 'called')
  end
end
```

Command match data includes `match['bot']`, `match['command']` and `match['expression']`. The `bot` match always checks against the `SlackRubyBot::Config.user` and `SlackRubyBot::Config.user_id` values obtained when the bot starts.

Operators are 1-letter long and are similar to commands. They don't require addressing a bot nor separating an operator from its arguments. The following class responds to `=2+2`.

```ruby
class MathBot < SlackRubyBot::Bot
  operator '=' do |client, data, match|
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
class Weather < SlackRubyBot::Bot
  match /^How is the weather in (?<location>\w*)\?$/ do |client, data, match|
    client.say(channel: data.channel, text: "The weather in #{match[:location]} is nice.")
  end
end
```

![](screenshots/weather.gif)

You can also capture multiple matchers with `scan`.

```ruby
class Market < SlackRubyBot::Bot
  scan(/([A-Z]{2,5})/) do |client, data, stocks|
    # lookup stock market price
  end
end
```

![](screenshots/market.gif)

See [examples/market](examples/market/marketbot.rb) for a working example.

### Providing description for your bot and commands

You can specify help information for bot or commands with `help` block, for example:

in case of bot:

```ruby
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
        'Bot provides detailed Weather Forecasts over a 10 day period updated four times a day.'
    end
  end

  # commands implementation
end
```

![](screenshots/help.png)

in case of your own command:

```ruby
class Deploy < SlackRubyBot::Commands::Base
  help do
    title 'deploy'
    desc 'deploys your app'
    long_desc 'command format: *deploy <branch> to <env>* where <env> is production or staging'
  end
end
```

### SlackRubyBot::Commands::Base

The `SlackRubyBot::Bot` class is DSL sugar deriving from `SlackRubyBot::Commands::Base`. For more involved bots you can organize the bot implementation into subclasses of `SlackRubyBot::Commands::Base` manually. By default a command class responds, case-insensitively, to its name. A class called `Phone` that inherits from `SlackRubyBot::Commands::Base` responds to `phone` and `Phone` and calls the `call` method when implemented.

```ruby
class Phone < SlackRubyBot::Commands::Base
  command 'call'

  def self.call(client, data, match)
    client.say(channel: data.channel, text: 'called')
  end
end
```

To respond to custom commands and to disable automatic class name matching, use the `command` keyword. The following command responds to `call` and `呼び出し` (call in Japanese).

```ruby
class Phone < SlackRubyBot::Commands::Base
  command 'call'
  command '呼び出し'

  def self.call(client, data, match)
    client.say(channel: data.channel, text: 'called')
  end
end
```

### Animated GIFs

The `SlackRubyBot::Client` implementation comes with GIF support.
To enable it simply add `gem 'giphy'` to your **Gemfile**.
**Note:** Bots send animated GIFs in default commands and errors.

```ruby
class Phone < SlackRubyBot::Commands::Base
  command 'call'

  def self.call(client, data, match)
    client.say(channel: data.channel, text: 'called', gif: 'phone')
    # Sends the text 'called' and a random GIF that matches the keyword 'phone'.
  end
end
```

If you use giphy for something else but don't want your bots to send GIFs you can set `ENV['SLACK_RUBY_BOT_SEND_GIFS']` or `SlackRubyBot::Config.send_gifs` to `false`. The latter takes precedence.

```ruby
SlackRubyBot.configure do |config|
  config.send_gifs = false
end
```

### Built-In Commands

Slack-ruby-bot comes with several built-in commands. You can re-define built-in commands, normally, as described above.

#### [bot name]

This is also known as the `default` command. Shows bot version and links.

#### [bot name] hi

Politely says 'hi' back.

#### [bot name] help

Get help.

### Hooks

Hooks are event handlers and respond to Slack RTM API [events](https://api.slack.com/events), such as [hello](lib/slack-ruby-bot/hooks/hello.rb) or [message](lib/slack-ruby-bot/hooks/message.rb). You can implement your own in a couple of ways:

#### Implement and register a Hook Handler

A Hook Handler is any object that respond to a `call` message, like a proc, instance of an object, class with a `call` class method, etc.

Hooks are registered onto the `SlackRubyBot::Server` instance, by way of a configuration hash

```ruby
SlackRubyBot::Server.new(hook_handlers: {
  hello: MyBot::Hooks::UserChange.new
})
```

or at any time by pushing it to the `HookSet`

```ruby
# Push an object that implements the
server.hooks.add(:hello, MyBot::Hooks::UserChange.new)

# Push a lambda to handle the event
server.hooks.add(:hello, ->(client, data) { puts "Hello!" })
```

For example, the following hook handles [user_change](https://api.slack.com/events/user_change), an event sent when a team member updates their profile or data. This can be useful to update the local user cache when a user is renamed.

```ruby
module MyBot
  module Hooks
    class UserChange
      def call(client, data)
        # data['user']['id'] contains the user ID
        # data['user']['name'] contains the new user name
        ...
      end
    end
  end
end
```

Hooks can also be written as blocks inside the `SlackBotRuby::Server` class, for example

```ruby
module MyBot
  class MyServer < SlackRubyBot::Server
    on 'hello' do |client, data|
      # data['user']['id'] contains the user ID
      # data['user']['name'] contains the new user name
    end
  end
end
```

These will get pushed into the hook set on initialization.

Either by configuration, explicit assignment or hook blocks, multiple handlers can exist for the same event type.

### Message Loop Protection

By default bots do not respond to their own messages. If you wish to change that behavior, set `allow_message_loops` to `true`.

```ruby
SlackRubyBot.configure do |config|
  config.allow_message_loops = true
end
```

### Logging

By default bots set a logger to `STDOUT` with `DEBUG` level. The logger is used in both the RealTime and Web clients. Silence logger as follows.

```ruby
SlackRubyBot::Client.logger.level = Logger::WARN
```

### Advanced Integration

You may want to integrate a bot or multiple bots into other systems, in which case a globally configured bot may not work for you. You may create instances of [SlackRubyBot::Server](lib/slack-ruby-bot/server.rb) which accepts `token`, `aliases` and `send_gifs`.

```ruby
EM.run do
  bot1 = SlackRubyBot::Server.new(token: token1, aliases: ['bot1'])
  bot1.start_async

  bot2 = SlackRubyBot::Server.new(token: token2, send_gifs: false, aliases: ['bot2'])
  bot2.start_async
end
```

For an example of advanced integration that supports multiple teams, see [slack-gamebot](https://github.com/dblock/slack-gamebot) and [playplay.io](http://playplay.io) that is built on top of it.

### RSpec Shared Behaviors

Slack-ruby-bot ships with a number of shared RSpec behaviors that can be used in your RSpec tests. Require 'slack-ruby-bot/rspec' in your `spec_helper.rb`.

* [behaves like a slack bot](lib/slack-ruby-bot/rspec/support/slack-ruby-bot/it_behaves_like_a_slack_bot.rb): A bot quacks like a Slack Ruby bot.
* [respond with slack message](lib/slack-ruby-bot/rspec/support/slack-ruby-bot/respond_with_slack_message.rb): The bot responds with a message.
* [respond with error](lib/slack-ruby-bot/rspec/support/slack-ruby-bot/respond_with_error.rb): An exception is raised inside a bot command.

### Useful Libraries

* [newrelic-slack-ruby-bot](https://github.com/dblock/newrelic-slack-ruby-bot): NewRelic instrumentation for slack-ruby-bot.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Upgrading

See [CHANGELOG](CHANGELOG.md) for a history of changes and [UPGRADING](UPGRADING.md) for how to upgrade to more recent versions.

## Copyright and License

Copyright (c) 2015-2016, [Daniel Doubrovkine](https://twitter.com/dblockdotorg), [Artsy](https://www.artsy.net) and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
