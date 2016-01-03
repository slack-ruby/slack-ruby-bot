module SlackRubyBot
  class App < Server
    def initialize(options = {})
      SlackRubyBot.configure do |config|
        config.token = ENV['SLACK_API_TOKEN'] || fail("Missing ENV['SLACK_API_TOKEN'].")
        config.aliases = ENV['SLACK_RUBY_BOT_ALIASES'].split(' ') if ENV['SLACK_RUBY_BOT_ALIASES']
      end
      Slack.configure do |config|
        config.token = SlackRubyBot.config.token
      end
      super
    end

    def config
      SlackRubyBot.config
    end

    def self.instance
      @instance ||= new
    end

    private

    def auth!
      super
      SlackRubyBot.configure do |config|
        config.url = client.auth['url']
        config.team = client.auth['team']
        config.user = client.auth['user']
        config.team_id = client.auth['team_id']
        config.user_id = client.auth['user_id']
      end
    end

    def reset!
      super
      SlackRubyBot.configure do |config|
        config.url = nil
        config.team = nil
        config.user = nil
        config.team_id = nil
        config.user_id = nil
      end
    end
  end
end
