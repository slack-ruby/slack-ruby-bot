module SlackRubyBot
  class App
    cattr_accessor :hooks

    include SlackRubyBot::Hooks::Hello
    include SlackRubyBot::Hooks::Message

    def initialize
      SlackRubyBot.configure do |config|
        config.token = ENV['SLACK_API_TOKEN'] || fail("Missing ENV['SLACK_API_TOKEN'].")
      end
      Slack.configure do |config|
        config.token = SlackRubyBot.config.token
      end
    end

    def config
      SlackRubyBot.config
    end

    def self.instance
      @instance ||= SlackRubyBot::App.new
    end

    def run
      auth!
      start!
    end

    def stop!
      client.stop
    end

    private

    def logger
      @logger ||= begin
        $stdout.sync = true
        Logger.new(STDOUT)
      end
    end

    def start!
      loop do
        client.start
        @client = nil
      end
    end

    def client
      @client ||= begin
        client = Slack.realtime
        hooks.each do |hook|
          client.on hook do |data|
            begin
              send hook, data
            rescue StandardError => e
              logger.error e
              begin
                Slack.chat_postMessage(channel: data['channel'], text: e.message) if data.key?('channel')
              rescue
                # ignore
              end
            end
          end
        end
        client
      end
    end

    def auth!
      auth = Slack.auth_test
      SlackRubyBot.configure do |config|
        config.url = auth['url']
        config.team = auth['team']
        config.user = auth['user']
        config.team_id = auth['team_id']
        config.user_id = auth['user_id']
      end
      logger.info "Welcome '#{SlackRubyBot.config.user}' to the '#{SlackRubyBot.config.team}' team at #{SlackRubyBot.config.url}."
    end

    def reset!
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
