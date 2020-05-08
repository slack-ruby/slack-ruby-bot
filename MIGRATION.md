# Migrating from Legacy API Tokens

New Slack Apps require authentication via OAuth, returning an access token that should be a drop-in replacement for `SLACK_API_TOKEN`. As of the time of writing, the tokens never expire, so you could potentially write your own OAuth flow to retrieve the access token separately. Alternatively, you could migrate to [slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server).

## Migrating to slack-ruby-bot-server
Overview:
- Create a new Slack App as [advised by Slack](https://api.slack.com/legacy/custom-integrations/legacy-tokens#migrating-from-legacy).
- Figure out how you want to persist your token. The gem supports ActiveRecord and Mongoid out-of-the-box and will create a `Team` model.
- Using a [sample app](https://github.com/slack-ruby/slack-ruby-bot-server/tree/master/sample_apps) as a base, move your `SlackRubyBot::Commands::Base` or `SlackRubyBot::Bot` concrete classes into the [`commands` folder](https://github.com/slack-ruby/slack-ruby-bot-server/tree/master/sample_apps/sample_app_activerecord/commands) and require it in `commands.rb`.
- Create a [Slack Button](https://api.slack.com/docs/slack-button), setting the redirect URL to `.../api/teams`. This is the OAuth grant redirect URL that will be run in the sample `config.ru` file. The endpoint will create a `Team` and store the access token in it.
- Run your app and authenticate with the Slack button.
