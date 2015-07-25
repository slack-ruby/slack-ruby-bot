Upgrading SlackRubyBot
======================

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


