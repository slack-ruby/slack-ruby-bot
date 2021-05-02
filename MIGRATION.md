# Migrating from Legacy API Tokens

New Slack Apps require authentication via OAuth, returning an access token that should be a drop-in replacement for `SLACK_API_TOKEN`. As of the time of writing, the tokens never expire, so you could potentially write your own OAuth flow to retrieve the access token separately.

Alternatively, you could migrate to [slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server). Note that this requires more infrastructure to support the OAuth flow.

## Migrating to slack-ruby-bot-server
1. Setup a new `slack-ruby-bot-server` project, following the [guidelines](https://github.com/slack-ruby/slack-ruby-bot-server#run-your-own).
2. Copy over the `SlackRubyBot::Commands::Base` or `SlackRubyBot::Bot` concrete classes from your `slack-ruby-bot` project into the new project. If you used a [sample app](https://github.com/slack-ruby/slack-ruby-bot-server/tree/master/sample_apps), copy them into the [`commands` folder](https://github.com/slack-ruby/slack-ruby-bot-server/tree/master/sample_apps/sample_app_activerecord/commands) and require it in `commands.rb`.
3. Create a [Slack Button](https://api.slack.com/docs/slack-button), setting the redirect URL to your OAuth grant endpoint. In the sample app, this would be `<ROOT_URL>/api/teams`.
4. Run your app and authenticate with the Slack button.

**NOTE**: By default, other teams would be able to authenticate and connect their workspaces using the same Slack button. If this is not what you want, you would need to prevent it.
