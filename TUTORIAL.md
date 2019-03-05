## Production Bot Tutorial

In this tutorial we'll implement [slack-mathbot](https://github.com/dblock/slack-mathbot).

### Introduction

A typical production Slack bot is a combination of a vanilla web server and a websocket application that talks to the [Slack Real Time Messaging API](https://api.slack.com/rtm). The web server is optional, but most people will run their Slack bots on [Heroku](https://dashboard.heroku.com) in which case a web server is required to prevent Heroku from shutting the bot down. It also makes it convenient to develop a bot and test using `foreman`.

### Getting Started

#### Gemfile

Create a `Gemfile` that uses [slack-ruby-bot](https://github.com/slack-ruby/slack-ruby-bot), [sinatra](https://github.com/sinatra/sinatra) (a web framework) and [puma](https://github.com/puma/puma) (a web server). For development we'll also use [foreman](https://github.com/theforeman/foreman) and write tests with [rspec](https://github.com/rspec/rspec).

```ruby
source 'https://rubygems.org'

gem 'slack-ruby-bot'
gem 'puma'
gem 'sinatra'
gem 'dotenv'
gem 'celluloid-io'

group :development, :test do
  gem 'rake'
  gem 'foreman'
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end
```

Run `bundle install` to get all the gems.

##### Passenger

To use passenger standalone change `gem 'puma'` to `gem 'passenger'`

#### Application

Create a folder called `slack-mathbot` and inside of it create `bot.rb`.

```ruby
module SlackMathbot
  class Bot < SlackRubyBot::Bot
  end
end
```

#### Commands

Create a folder called `slack-mathbot/commands` and inside of it create `calculate.rb`. For now this calculator will always return 4.

```ruby
module SlackMathbot
  module Commands
    class Calculate < SlackRubyBot::Commands::Base
      command 'calculate' do |client, data, _match|
        client.say(channel: data.channel, text: '4')
      end
    end
  end
end
```

#### Require Everything

Create a `slack-mathbot.rb` at the root and require the above files.

```ruby
require 'slack-ruby-bot'
require 'slack-mathbot/commands/calculate'
require 'slack-mathbot/bot'
```

#### Web Server

We will need to keep the bot alive on Heroku, so create `web.rb`.

```ruby
require 'sinatra/base'

module SlackMathbot
  class Web < Sinatra::Base
    get '/' do
      'Math is good for you.'
    end
  end
end
```

#### Config.ru

Tie all the pieces together in `config.ru` which creates a thread for the bot and runs the web server on the main thread.

```ruby
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dotenv'
Dotenv.load

require 'slack-mathbot'
require 'web'

Thread.abort_on_exception = true

Thread.new do
  begin
    SlackMathbot::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run SlackMathbot::Web
```

### Create a Bot User

In Slack administration create a new Bot Integration under [services/new/bot](http://slack.com/services/new/bot).

![](screenshots/register-bot.png)

On the next screen, note the API token.

#### .env

Create a `.env` file with the API token from above and make sure to add it to `.gitignore`.

```
SLACK_API_TOKEN=...
```

### Procfile

Create a `Procfile` which `foreman` will use when you run the `foreman start` command below.

```
web: bundle exec puma -p $PORT
```

#### Passenger

If you want to use passenger locally change it to:

```
web: bundle exec passenger -p $PORT
```

Add the following folders to your project root: 'tmp/', 'log/', 'public/' 
Passenger will automatically save the local logs to these folders.

Optional: Change the port in a `Passenger.json`

```
{
  "port": "1234" 
}
```

### Run the Bot

Run `foreman start`. Your bot should be running.

```
14:32:32 web.1  | Puma starting in single mode...
14:32:32 web.1  | * Version 2.11.3 (ruby 2.1.6-p336), codename: Intrepid Squirrel
14:32:32 web.1  | * Min threads: 0, max threads: 16
14:32:32 web.1  | * Environment: development
14:32:35 web.1  | * Listening on tcp://0.0.0.0:5000
14:32:35 web.1  | Use Ctrl-C to stop
14:32:36 web.1  | I, [2015-07-10T14:32:36.216663 #98948]  INFO -- : Welcome 'mathbot' to the 'xyz' team at https://xyz.slack.com/.
14:32:36 web.1  | I, [2015-07-10T14:32:36.766955 #98948]  INFO -- : Successfully connected to https://xyz.slack.com/.
```

### Try

Invite the bot to a channel via `/invite [bot name]` and send it a `calculate` command with `[bot name] calculate 2+2`. It will respond with `4` from the code above.

### Write Tests

#### Spec Helper

Create `spec/spec_helper.rb` that includes the bot files and shared RSpec support from slack-ruby-bot.

```ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

require 'slack-ruby-bot/rspec'
require 'slack-mathbot'
```

#### Test the Bot Application

Create a test for the bot application itself in `spec/slack-mathbot/bot_spec.rb`.

```ruby
require 'spec_helper'

describe SlackMathbot::Bot do
  def app
    SlackMathbot::Bot.instance
  end

  subject { app }

  it_behaves_like 'a slack ruby bot'
end
```

#### Test a Command

Create a test for the `calculate` command in `spec/slack-mathbot/commands/calculate_spec.rb`. The bot is addressed by its user name.

```ruby
require 'spec_helper'

describe SlackMathbot::Commands::Calculate do
  def app
    SlackMathbot::Bot.instance
  end

  subject { app }

  it 'returns 4' do
    expect(message: "#{SlackRubyBot.config.user} calculate 2+2", channel: 'channel').to respond_with_slack_message('4')
  end
end
```

See [lib/slack-ruby-bot/rspec/support/slack-ruby-bot](lib/slack-ruby-bot/rspec/support/slack-ruby-bot) for other shared RSpec behaviors.

### Deploy

See [DEPLOYMENT](DEPLOYMENT.md) for how to deploy your bot to production.
