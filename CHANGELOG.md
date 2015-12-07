### 0.5.1 (Next)

* [#33](https://github.com/dblock/slack-ruby-bot/pull/33): `SlackRubyBot::App.instance` now creates an instance of the class on which it is called - [@dmvt](https://github.com/dmvt).
* Your contribution here.

### 0.5.0 (12/7/2015)

* Disable animated GIFs via `SlackRubyBot::Config.send_gifs` or ENV['SLACK_RUBY_BOT_SEND_GIFS'] - [@dblock](https://github.com/dblock).
* `SlackRubyBot::Server` supports `restart!` with retry - [@dblock](https://github.com/dblock).
* `SlackRubyBot::Server` publicly supports `auth!`, `start!` and `start_async` that make up a `run` loop - [@dblock](https://github.com/dblock).
* Extracted `SlackRubyBot::Server` from `SlackRubyBot::App` - [@dblock](https://github.com/dblock).
* Fix: explicitly require 'giphy' - [@dblock](https://github.com/dblock).
* Fix: undefined method `stop` for `Slack::RealTime::Client` - [@dblock](https://github.com/dblock).
* [#29](https://github.com/dblock/slack-ruby-bot/pull/29): Fixed bot failing to correctly respond to unknown commands when queried with format `@botname` - [@crayment](https://github.com/crayment).
* [#30](https://github.com/dblock/slack-ruby-bot/pull/30): Fix RegexpError when parsing command - [@kuboshizuma](https://github.com/kuboshizuma).

### 0.4.5 (10/29/2015)

* [#23](https://github.com/dblock/slack-ruby-bot/pull/23): Fixed `match` that forced bot name into the expression being evaluated - [@dblock](https://github.com/dblock).
* [#22](https://github.com/dblock/slack-ruby-bot/issues/22), [slack-ruby-client#17](https://github.com/dblock/slack-ruby-client/issues/17): Do not respond to messages from self, override with `allow_message_loops` - [@dblock](https://github.com/dblock).

### 0.4.4 (10/5/2015)

* [#17](https://github.com/dblock/slack-ruby-bot/issues/17): Address bot by `name:` - [@dblock](https://github.com/dblock).
* [#19](https://github.com/dblock/slack-ruby-bot/issues/19): Retry on `Faraday::Error::TimeoutError`, `TimeoutError` and `SSLError` - [@dblock](https://github.com/dblock).
* [#3](https://github.com/dblock/slack-ruby-bot/issues/3): Retry on `migration_in_progress` errors during `rtm.start` - [@dblock](https://github.com/dblock).
* Respond to direct messages without being addressed by name - [@dblock](https://github.com/dblock).
* Added `send_gif`, to allow GIFs to be sent without text - [@maclover7](https://github.com/maclover7).

### 0.4.3 (8/21/2015)

* [#13](https://github.com/dblock/slack-ruby-bot/issues/13): You can now address the bot by its Slack @id - [@dblock](https://github.com/dblock).

### 0.4.2 (8/20/2015)

* [#12](https://github.com/dblock/slack-ruby-bot/issues/12): Added support for bot aliases - [@dblock](https://github.com/dblock).

### 0.4.1 (7/25/2015)

* Use a real client in `respond_with_slack_message` expectaions - [@dblock](https://github.com/dblock).

### 0.4.0 (7/25/2015)

* Using [slack-ruby-client](https://github.com/dblock/slack-ruby-client) - [@dblock](https://github.com/dblock).
* Use RealTime API to post messages - [@dblock](https://github.com/dblock).

### 0.3.1 (7/21/2015)

* [#8](https://github.com/dblock/slack-ruby-bot/issues/8): Fix: `undefined method 'strip!' for nil:NilClass` on nil message - [@dblock](https://github.com/dblock).

### 0.3.0 (7/19/2015)

* [#5](https://github.com/dblock/slack-ruby-bot/issues/5): Added support for free-formed routes via `match` - [@dblock](https://github.com/dblock).
* [#6](https://github.com/dblock/slack-ruby-bot/issues/6): Commands and operators take blocks - [@dblock](https://github.com/dblock).
* [#4](https://github.com/dblock/slack-ruby-bot/issues/4): Messages are posted with `as_user: true` by default - [@dblock](https://github.com/dblock).

### 0.2.0 (7/10/2015)

* Sending `send_message` with nil or empty text will yield `Nothing to see here.` with a GIF instead of `no_text` - [@dblock](https://github.com/dblock).
* Added support for operators with `operator [name]` - [@dblock](https://github.com/dblock).
* Added support for custom commands with `command [name]` - [@dblock](https://github.com/dblock).

### 0.1.0 (6/2/2015)

* Initial public release - [@dblock](https://github.com/dblock).
