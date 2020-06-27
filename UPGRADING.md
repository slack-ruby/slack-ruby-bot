Upgrading SlackRubyBot
======================

### Upgrading to >= 0.16.0

#### Removed GIF support

GIF, Giphy and other animated GIF support has been removed. Remove `gif` options from all `client.say(gif: 'keyword')` method calls, the `GIPHY_API_KEY` ENV var, `gem 'giphy'` or `gem 'GiphyClient'`, and any references to `send_gifs`. The previously deprecated `SlackRubyBot::Commands::Base#send_message`, `send_message_with_gif` and `send_gif` methods have also been removed.

See [#261](https://github.com/slack-ruby/slack-ruby-bot/issues/261) for details.

#### Removed deprecated `server.hooks`

The previously deprecated `SlackRubyBot::Server#hooks` has been removed.

See [#266](https://github.com/slack-ruby/slack-ruby-bot/issues/266) for details.

### Upgrading to >= 0.15.0

#### Set up VCR explicitly

Requiring `slack-ruby-bot/rspec` will no longer set up [VCR](https://rubygems.org/gems/vcr) anymore. If your spec suite implicitly relies on this you would need to set up VCR explicitly in your spec suite. Just follow standard VCR documentation.

See [#258](https://github.com/slack-ruby/slack-ruby-bot/pull/258) for more information.

### Upgrading to >= 0.14.0

#### Bot Messages Disabled

By default bots will no longer respond to other bots. This caused confusing "I don't understand this command." errors when DMing the bot and rendering URLs that were being sent back as DMs. If you wish to restore the old behavior, set `allow_bot_messages` to `true`.

```ruby
SlackRubyBot.configure do |config|
  config.allow_bot_messages = true
end
```

See [#250](https://github.com/slack-ruby/slack-ruby-bot/pull/250) for more information.

### Upgrading to >= 0.13.0

#### Minimum Ruby Version

Ruby 2.3 or later is now required.

See [#246](https://github.com/slack-ruby/slack-ruby-bot/pull/246) for more information.

### Upgrading to >= 0.12.0

#### Remove any references to `SlackRubyBot::Server#restart!`

We have removed `SlackRubyBot::Server#restart!` since the [`slack-ruby-client`](https://github.com/slack-ruby/slack-ruby-client/blob/master/CHANGELOG.md) now restarts any connection that was not intentionally stopped via `SlackRubyBot::Server#stop!`.

### Upgrading to >= 0.10.4

#### Replace `server.hooks.add` with `server.on`

We have deprecated `SlackRubyBot::Server#hooks` in favor of `SlackRubyBot::Server#on` instance method. All users using `SlackRubyBot::Server#hooks` method should
change their codebase and use the new method instead. Method signature is not affected.

Example:

```ruby
  # Given server is an instance of SlackRubyBot::Server
  #
  # Before
  server.hooks.add :hello, Greet.new

  # After
  server.on :hello, Greet.new
```

### Upgrading to >= 0.9.0

#### Add giphy to your Gemfile for GIF support

The dependency on the `giphy` gem was dropped and GIFs don't appear by default. If you want GIF support, add `gem 'giphy'` to your **Gemfile**.

You should not need to make any changes if you had already disabled GIFs for your bot.

See [#89](https://github.com/slack-ruby/slack-ruby-bot/pull/89) for more information.

### Upgrading to >= 0.8.0

#### Require a concurrency library

The `faye-websocket` library is no longer required by default. Add either `faye-websocket` or `celluiloid-io` to your `Gemfile` depending on which concurrency implementation you'd like to use. We recommend `celluloid-io` moving forward.

#### Hook::Base was removed, explicitly register any custom hook classes

Hook classes are now handled differently, namely they are explicitly registered into `SlackRubyBot::Server` via a configuration option (`hook_handlers`) or by passing a similar hash later on through the `add_hook_handlers` method. Including Hook classes directly into the server class is no longer needed.

A hook is actioned via a `call` message onto the handler object (this can be anything that responds to that), so you'll need to rename your method.

Finally, you can now register multiple hooks for the same event, so if you had any code to remove default hooks, you'll need to change it so you pass a configuration hash into `Server`

### Upgrading to >= 0.7.0

#### Simplify Match Expression Checking

The regular expression parser for commands will now include a `nil` value for `expression` when an expression is not present. You can therefore no longer rely on checking `match.names.include?('expression')`, instead check `match['expression']`.

#### Remove any bot.auth! calls

SlackRubyBot 0.6.x versions invoked a method called `auth!`, which caused a pre-flight authentication via Slack Web API `auth_test` method and collected a number of properties, such as client and team ID or name. This method has been removed in favor of using data available in the `Slack::RealTime::Client` local store introduced in [slack-ruby-client#54](https://github.com/slack-ruby/slack-ruby-client/issues/54). Remove any explicit calls to this method.

### Upgrading to >= 0.6.0

While entirely compatible with the 0.5.x series, a number of methods have been deprecated and will be removed in the next release.

#### Replace SlackRubyBot::Commands::Base#call with command, operator or match

Prefer `command`, `operator` or `match` with a block instead of implementing a `self.call` method.

Before:

```ruby
require 'slack-ruby-bot'

class Bot < SlackRubyBot::Bot
  command 'ping'

  def self.call(client, data, match)
    ...
  end
end
```

After:

```ruby
require 'slack-ruby-bot'

class Bot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    ...
  end
end
```

#### Replace send_message, send_message_with_gif and send_gif with client.say

Use `client.say` instead of `send_message`, `send_message_with_gif` and `send_gif` in commands.

Before:

```ruby
class Bot < SlackRubyBot::Bot
 command 'one' do |client, data, match|
  send_message client, data.channel, 'Text.'
 end

 command 'two' do |client, data, match|
  send_message_with_gif client, data.channel, "Text.", 'keyword'
 end

 command 'three' do |client, data, match|
  send_gif client, data.channel, 'keyword'
 end
end
```

After:

```ruby
class Bot < SlackRubyBot::Bot
 command 'one' do |client, data, match|
  client.say(channel: data.channel, text: 'Text.')
 end

 command 'two' do |client, data, match|
  client.say(channel: data.channel, text: 'Text.', gif: 'keyword')
 end

 command 'three' do |client, data, match|
  client.say(channel: data.channel, gif: 'keyword')
 end
end
```

#### For basic bots replace SlackRubyBot::App with SlackRubyBot::Bot and implement commands inline

Before:

```ruby
module PongBot
  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    command 'ping' do |client, data, _match|
      client.message(text: 'pong', channel: data.channel)
    end
  end
end

PongBot::App.instance.run
```

After:

```ruby
class Bot < SlackRubyBot::Bot
  command 'ping' do |client, data, _match|
    client.say(text: 'pong', channel: data.channel)
  end
end

Bot.run
```

### Upgrading to >= 0.4.0

This version uses [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client) instead of [slack-ruby-gem](https://github.com/aki017/slack-ruby-gem).

The command interface now takes a `client` parameter, which is the RealTime Messaging API instance. Add the new parameter to all `call` calls in classes that inherit from `SlackRubyBot::Commands::Base`.

Before:

```ruby
def self.call(data, match)
  ...
end
```

After:

```ruby
def self.call(client, data, match)
  ...
end
```

This also applies to `command`, `operator` and `match` blocks.

Before:

```ruby
command 'ping' do |data, match|
  ...
end
```

After:

```ruby
command 'ping' do |client, data, match|
  ...
end
```

You can now send messages directly via the RealTime Messaging API.

```ruby
client.message text: 'text', channel: 'channel'
```

Otherwise you must now pass the `client` parameter to `send_message` and `send_message_with_gif`.

```ruby
def self.call(client, data, match)
  send_message client, data.channel, 'hello'
end
```

```ruby
def self.call(client, data, match)
  send_message_with_gif client, data.channel, 'hello', 'hi'
end
```
