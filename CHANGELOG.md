### 0.11.1 (05/06/2018)

* [#187](https://github.com/slack-ruby/slack-ruby-bot/pull/187): Added support for the [official Giphy SDK](https://github.com/Giphy/giphy-ruby-client) - [@dblock](https://github.com/dblock).
* [#185](https://github.com/slack-ruby/slack-ruby-bot/pull/185): Log backtrace of exceptions - [@dblock](https://github.com/dblock).

### 0.11.0 (04/02/2018)

* [#182](https://github.com/slack-ruby/slack-ruby-bot/pull/182): Refactor CommandsHelper class and Help module - [@mdudzinski](https://github.com/mdudzinski).
* [#180](https://github.com/slack-ruby/slack-ruby-bot/pull/180): Allow to respond to text in attachments #177 - [@mdudzinski](https://github.com/mdudzinski).
* [#173](https://github.com/slack-ruby/slack-ruby-bot/pull/173): Exposing SlackRubyBot::CommandsHelper.find_command_help_attrs - [@alexagranov](https://github.com/alexagranov).
* [#179](https://github.com/slack-ruby/slack-ruby-bot/pull/179): Allow multiline expression - [@tiagotex](https://github.com/tiagotex).
* [#183](https://github.com/slack-ruby/slack-ruby-bot/pull/183): Add missing test dependency to readme.md - [@hoshinotsuyoshi](https://github.com/hoshinotsuyoshi).

### 0.10.5 (10/15/2017)

* Refactored `SlackRubyBot::MVC::Controller::Base`, consolidated ivar handling, centralized object allocations and DRYed up the code - [@chuckremes](https://github.com/chuckremes).
* [#157](https://github.com/slack-ruby/slack-ruby-bot/pull/157): Added `respond_with_slack_messages` expectation - [@gcraig99](https://github.com/gcraig99).
* [#160](https://github.com/slack-ruby/slack-ruby-bot/pull/160): Fixed `respond_with_slack_message(s)` expectation failures - [@gcraig99](https://github.com/gcraig99).
* [#163](https://github.com/slack-ruby/slack-ruby-bot/pull/163): Allow `command` to accept regular expressions - [@kstole](https://github.com/kstole).
* [#166](https://github.com/slack-ruby/slack-ruby-bot/pull/166): Allow special characters and capitals in bot aliases - [@kstole](https://github.com/kstole).

### 0.10.4 (07/05/2017)

* [#149](https://github.com/slack-ruby/slack-ruby-bot/pull/149): Add `logger` configuration to set a custom logger - [@upscent](https://github.com/upscent).
* [#147](https://github.com/slack-ruby/slack-ruby-bot/pull/147): Adds `server.on` as a shortcut for `hooks.add` and deprecate `hooks` method - [@laertispappas](https://github.com/laertispappas).
* [#143](https://github.com/slack-ruby/slack-ruby-bot/pull/143): Provide `permitted?` method to allow for simple authorization extensions - [@chuckremes](https://github.com/chuckremes).

### 0.10.3 (06/15/2017)

* [#145](https://github.com/slack-ruby/slack-ruby-bot/pull/145): Map multiple command strings to same controller method - [@chuckremes](https://github.com/chuckremes).
* [#144](https://github.com/slack-ruby/slack-ruby-bot/pull/144): Support usage of commands with embedded spaces when using Controller methods - [@chuckremes](https://github.com/chuckremes).

### 0.10.2 (06/03/2017)

* [#137](https://github.com/slack-ruby/slack-ruby-bot/pull/137): Add Model-View-Controller classes to allow for more explicit control over how `command`s are designed - [@chuckremes](https://github.com/chuckremes).
* [#130](https://github.com/slack-ruby/slack-ruby-bot/issues/130): Added test dependencies in TUTORIAL.md - [@jbristow](https://github.com/jbristow).

### 0.10.1 (2/12/2017)

* [#113](https://github.com/slack-ruby/slack-ruby-bot/issues/113): Fixed commands in subclassed `SlackRubyBot::Bot` - [@dblock](https://github.com/dblock).

### 0.10.0 (2/9/2017)

* [#111](https://github.com/slack-ruby/slack-ruby-bot/pull/111): Default keyword for GIFs in invalid commands has been changed from `idiot` to `understand` - [@dblock](https://github.com/dblock).
* [#98](https://github.com/slack-ruby/slack-ruby-bot/pull/98): Fixed a couple of problems in TUTORIAL.md - [@edruder](https://github.com/edruder).
* [#95](https://github.com/slack-ruby/slack-ruby-bot/pull/95): Log team name and ID on successful connection - [@dblock](https://github.com/dblock).
* [#94](https://github.com/slack-ruby/slack-ruby-bot/pull/94): Use the slack-ruby-danger gem - [@dblock](https://github.com/dblock).
* [#86](https://github.com/dblock/slack-ruby-bot/pull/86): Fix: help statements from classes that do not directly inherit from `Base` appear in `bot help` - [@maclover7](https://github.com/maclover7).
* [#96](https://github.com/slack-ruby/slack-ruby-bot/pull/96): Support help statements in anonymous command and bot classes - [@dblock](https://github.com/dblock).
* [#75](https://github.com/slack-ruby/slack-ruby-bot/pull/101): Fix: Guarantee order of commands based on load order - [@gconklin](https://github.com/gconklin).

### 0.9.0 (8/29/2016)

* [#89](https://github.com/slack-ruby/slack-ruby-bot/pull/89): Drop giphy dependency - [@tmsrjs](https://github.com/tmsrjs).
* [#92](https://github.com/slack-ruby/slack-ruby-bot/pull/92): Added [danger](http://danger.systems), PR linting - [@dblock](https://github.com/dblock).

### 0.8.2 (7/10/2016)

* [#85](https://github.com/slack-ruby/slack-ruby-bot/issues/85): Fix: regression in bot instance logging - [@dblock](https://github.com/dblock).

### 0.8.1 (7/10/2016)

* [#69](https://github.com/slack-ruby/slack-ruby-bot/pull/69): Ability to add help info to bot and commands - [@accessd](https://github.com/accessd).
* [#75](https://github.com/slack-ruby/slack-ruby-bot/issues/75): Guarantee order of command evaluation - [@dblock](https://github.com/dblock).
* [#76](https://github.com/slack-ruby/slack-ruby-bot/issues/76): Infinity error when app disabled - [@slayershadow](https://github.com/SlayerShadow).
* [#81](https://github.com/slack-ruby/slack-ruby-bot/pull/81): Removed dependency on Bundler - [@derekddecker](https://github.com/derekddecker).
* [#84](https://github.com/slack-ruby/slack-ruby-bot/pull/84): Removed dependency on ActiveSupport - [@rmulligan](https://github.com/rmulligan).

### 0.8.0 (5/5/2016)

* [#32](https://github.com/slack-ruby/slack-ruby-bot/issues/32): Don't include `faye-websocket` by default, support `celluloid-io` - [@dblock](https://github.com/dblock).
* [#54](https://github.com/slack-ruby/slack-ruby-bot/pull/54): Improvements to Hook configuration - [@dramalho](https://github.com/dramalho).

### 0.7.0 (3/6/2016)

* Improved regular expression matching performance with less matching per command - [@dblock](https://github.com/dblock).
* Don't attempt to pre-authenticate via `auth!`, use RealTime client local store - [@dblock](https://github.com/dblock).
* Extended `match` with `scan` that can make multiple captures - [@dblock](https://github.com/dblock).

### 0.6.2 (2/4/2016)

* [#44](https://github.com/slack-ruby/slack-ruby-bot/pull/44): Bot graceful shutdown - [@accessd](https://github.com/accessd).

### 0.6.1 (1/29/2016)

* [#43](https://github.com/slack-ruby/slack-ruby-bot/issues/43): Issuing a `bot` command terminates bot - [@dblock](https://github.com/dblock).
* [#40](https://github.com/slack-ruby/slack-ruby-bot/pull/40): Added `SlackRubyBot::Config.reset!` - [@accessd](https://github.com/accessd).

### 0.6.0 (1/9/2016)

* Deprecated `SlackRubyBot::Base#send_message`, `send_message_with_gif` and `send_gif` in favor of `client.say` - [@dblock](https://github.com/dblock).

### 0.5.5 (1/4/2016)

* Added `SlackRubyBot::Bot` DSL sugar - [@dblock](https://github.com/dblock).

### 0.5.4 (1/3/2016)

* Enable setting `send_gifs` per instance of `SlackRubyBot::Server` - [@dblock](https://github.com/dblock).

### 0.5.3 (12/28/2015)

* [#36](https://github.com/slack-ruby/slack-ruby-bot/issues/36): Fix: non-English bot aliases now work - [@dblock](https://github.com/dblock).

### 0.5.2 (12/26/2015)

* Enable setting bot aliases per instance of `SlackRubyBot::Server` - [@dblock](https://github.com/dblock).

### 0.5.1 (12/23/2015)

* Fix: restart sync vs. async - [@dblock](https://github.com/dblock).
* [#33](https://github.com/slack-ruby/slack-ruby-bot/pull/33): `SlackRubyBot::App.instance` now creates an instance of the class on which it is called - [@dmvt](https://github.com/dmvt).

### 0.5.0 (12/7/2015)

* Disable animated GIFs via `SlackRubyBot::Config.send_gifs` or ENV['SLACK_RUBY_BOT_SEND_GIFS'] - [@dblock](https://github.com/dblock).
* `SlackRubyBot::Server` supports `restart!` with retry - [@dblock](https://github.com/dblock).
* `SlackRubyBot::Server` publicly supports `auth!`, `start!` and `start_async` that make up a `run` loop - [@dblock](https://github.com/dblock).
* Extracted `SlackRubyBot::Server` from `SlackRubyBot::App` - [@dblock](https://github.com/dblock).
* Fix: explicitly require 'giphy' - [@dblock](https://github.com/dblock).
* Fix: undefined method `stop` for `Slack::RealTime::Client` - [@dblock](https://github.com/dblock).
* [#29](https://github.com/slack-ruby/slack-ruby-bot/pull/29): Fixed bot failing to correctly respond to unknown commands when queried with format `@botname` - [@crayment](https://github.com/crayment).
* [#30](https://github.com/slack-ruby/slack-ruby-bot/pull/30): Fix RegexpError when parsing command - [@kuboshizuma](https://github.com/kuboshizuma).

### 0.4.5 (10/29/2015)

* [#23](https://github.com/slack-ruby/slack-ruby-bot/pull/23): Fixed `match` that forced bot name into the expression being evaluated - [@dblock](https://github.com/dblock).
* [#22](https://github.com/slack-ruby/slack-ruby-bot/issues/22), [slack-ruby-client#17](https://github.com/slack-ruby/slack-ruby-client/issues/17): Do not respond to messages from self, override with `allow_message_loops` - [@dblock](https://github.com/dblock).

### 0.4.4 (10/5/2015)

* [#17](https://github.com/slack-ruby/slack-ruby-bot/issues/17): Address bot by `name:` - [@dblock](https://github.com/dblock).
* [#19](https://github.com/slack-ruby/slack-ruby-bot/issues/19): Retry on `Faraday::Error::TimeoutError`, `TimeoutError` and `SSLError` - [@dblock](https://github.com/dblock).
* [#3](https://github.com/slack-ruby/slack-ruby-bot/issues/3): Retry on `migration_in_progress` errors during `rtm.start` - [@dblock](https://github.com/dblock).
* Respond to direct messages without being addressed by name - [@dblock](https://github.com/dblock).
* Added `send_gif`, to allow GIFs to be sent without text - [@maclover7](https://github.com/maclover7).

### 0.4.3 (8/21/2015)

* [#13](https://github.com/slack-ruby/slack-ruby-bot/issues/13): You can now address the bot by its Slack @id - [@dblock](https://github.com/dblock).

### 0.4.2 (8/20/2015)

* [#12](https://github.com/slack-ruby/slack-ruby-bot/issues/12): Added support for bot aliases - [@dblock](https://github.com/dblock).

### 0.4.1 (7/25/2015)

* Use a real client in `respond_with_slack_message` expectaions - [@dblock](https://github.com/dblock).

### 0.4.0 (7/25/2015)

* Using [slack-ruby-client](https://github.com/slack-ruby/slack-ruby-client) - [@dblock](https://github.com/dblock).
* Use RealTime API to post messages - [@dblock](https://github.com/dblock).

### 0.3.1 (7/21/2015)

* [#8](https://github.com/slack-ruby/slack-ruby-bot/issues/8): Fix: `undefined method 'strip!' for nil:NilClass` on nil message - [@dblock](https://github.com/dblock).

### 0.3.0 (7/19/2015)

* [#5](https://github.com/slack-ruby/slack-ruby-bot/issues/5): Added support for free-formed routes via `match` - [@dblock](https://github.com/dblock).
* [#6](https://github.com/slack-ruby/slack-ruby-bot/issues/6): Commands and operators take blocks - [@dblock](https://github.com/dblock).
* [#4](https://github.com/slack-ruby/slack-ruby-bot/issues/4): Messages are posted with `as_user: true` by default - [@dblock](https://github.com/dblock).

### 0.2.0 (7/10/2015)

* Sending `send_message` with nil or empty text will yield `Nothing to see here.` with a GIF instead of `no_text` - [@dblock](https://github.com/dblock).
* Added support for operators with `operator [name]` - [@dblock](https://github.com/dblock).
* Added support for custom commands with `command [name]` - [@dblock](https://github.com/dblock).

### 0.1.0 (6/2/2015)

* Initial public release - [@dblock](https://github.com/dblock).
