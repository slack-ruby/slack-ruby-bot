# Slack Migrations

### Migrating Classic Slack Ruby Bots to Granular Permissions

As of December 4th, 2020 Slack no longer accept resubmissions from apps that are not using granular permissions, or so-called "classic apps". On November 18, 2021 Slack will start delisting apps that have not migrated to use granular permissions.

This library implements real-time support for classic apps. You should not be building a new bot with it and use [slack-ruby-bot-server-events](https://github.com/slack-ruby/slack-ruby-bot-server-events) instead. For a rudimentary bot you can even start with [slack-ruby-bot-server-events-app-mentions](https://github.com/slack-ruby/slack-ruby-bot-server-events-app-mentions).

See [slack-ruby-bot-server#migrating](https://github.com/slack-ruby/slack-ruby-bot-server/blob/master/MIGRATING.md) for help with migrations.

### Migrating from Really Old Legacy API Tokens

Slack Apps since around 2018 required authentication via OAuth, returning an access token that should be a drop-in replacement for `SLACK_API_TOKEN`. As of the time of writing, the tokens never expire, so you could potentially write your own OAuth flow to retrieve the access token separately.

We recommend you migrate to [slack-ruby-bot-server](https://github.com/slack-ruby/slack-ruby-bot-server) that supports the OAuth flow and subsequently to [slack-ruby-bot-server-events](https://github.com/slack-ruby/slack-ruby-bot-server-events) to handle Slack events with granular permissions.

#### Migrating to slack-ruby-bot-server

1. Setup a new `slack-ruby-bot-server` project, following the [guidelines](https://github.com/slack-ruby/slack-ruby-bot-server#run-your-own).
2. Copy over the `SlackRubyBot::Commands::Base` or `SlackRubyBot::Bot` concrete classes from your `slack-ruby-bot` project into the new project. If you used a [sample app](https://github.com/slack-ruby/slack-ruby-bot-server/tree/master/sample_apps), copy them into the [`commands` folder](https://github.com/slack-ruby/slack-ruby-bot-server/tree/master/sample_apps/sample_app_activerecord/commands) and require it in `commands.rb`.
3. Create a [Slack Button](https://api.slack.com/docs/slack-button), setting the redirect URL to your OAuth grant endpoint. In the sample app, this would be `<ROOT_URL>/api/teams`.
4. Run your app and authenticate with the Slack button.

**NOTE**: By default, other teams would be able to authenticate and connect their workspaces using the same Slack button. If this is not what you want, you would need to prevent it.
