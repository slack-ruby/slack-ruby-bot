Slack-Ruby-Bot
==============

[![Gem Version](https://badge.fury.io/rb/slack-ruby-bot.svg)](http://badge.fury.io/rb/slack-ruby-bot)
[![Build Status](https://travis-ci.org/dblock/slack-ruby-bot.png)](https://travis-ci.org/dblock/slack-ruby-bot)

A generic Slack bot framework written in Ruby. This library does all the heavy lifting so you can focus on implementing slack bot commands, without introducing unnecessary requirements or limitations. It's a Slack bot boilerplate.

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
    def self.call(data, command, arguments)
      send_message data.channel, 'pong'
    end
  end
end

PongBot::App.instance.run
```

After [registering the bot](DEPLOYMENT.md), run with `SLACK_API_KEY=... bundle exec ruby pongbot.rb`. Have the bot join a channel and send it a ping.

![](screenshots/demo.gif)

### More Involved Examples

A Slack bot is commonly a combination of a vanilla web server and a websocket application that talks to the Slack RealTime API. The web server is optional, but most people will run their Slack bots on Heroku in which case a web server is required to prevent Heroku from shutting the bot down. It also makes it convenient to develop and test using `foreman`.

* [slack-mathbot](https://github.com/dblock/slack-mathbot)

### Built-In Commands

#### [bot name]

Shows bot version and links.

#### [bot name] hi

Politely says 'hi' back.

#### [bot name] help

Get help.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## Copyright and License

Copyright (c) 2015, Daniel Doubrovkine, Artsy and [Contributors](CHANGELOG.md).

This project is licensed under the [MIT License](LICENSE.md).
