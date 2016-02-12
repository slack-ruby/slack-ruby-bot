Upgrading SlackRubyBot
======================

### Upgrading to >= 0.7.0

#### Simplify Match Expression Checking

The regular expression parser for commands will now include a `nil` value for `expression` when an expression is not present. You can therefore no longer rely on checking `match.names.include?('expression')`, instead check `match['expression']`.

#### Remove any bot.auth! calls

SlackRubyBot 0.6.x versions invoked a method called `auth!`, which caused a pre-flight authentication via Slack Web API `auth_test` method and collected a number of properties, such as client and team ID or name. This method has been removed in favor of using data available in the `Slack::RealTime::Client` local store introduced in [slack-ruby-client#54](https://github.com/dblock/slack-ruby-client/issues/54). Remove any explicit calls to this method.

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

This version uses [slack-ruby-client](https://github.com/dblock/slack-ruby-client) instead of [slack-ruby-gem](https://github.com/aki017/slack-ruby-gem).

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


