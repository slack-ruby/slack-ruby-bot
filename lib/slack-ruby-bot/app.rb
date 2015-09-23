module SlackRubyBot
  class App
    cattr_accessor :hooks

    include SlackRubyBot::Hooks::Hello
    include SlackRubyBot::Hooks::Message

    def initialize
      SlackRubyBot.configure do |config|
        config.token = ENV['SLACK_API_TOKEN'] || fail("Missing ENV['SLACK_API_TOKEN'].")
        config.aliases = ENV['SLACK_RUBY_BOT_ALIASES'].split(' ') if ENV['SLACK_RUBY_BOT_ALIASES']
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
        begin
          client.start!
        rescue Slack::Web::Api::Error => e
          logger.error e
          case e.message
          when 'migration_in_progress'
            sleep 1 # ignore, try again
          else
            raise e
          end
        rescue Faraday::Error::TimeoutError, Faraday::Error::ConnectionFailed, Faraday::Error::SSLError => e
          logger.error e
          sleep 1 # ignore, try again
        rescue StandardError => e
          logger.error e
          raise e
        ensure
          @client = nil
        end
      end
    end

    def client
      @client ||= begin
        client = Slack::RealTime::Client.new
        hooks.each do |hook|
          client.on hook do |data|
            begin
              send hook, client, data
            rescue StandardError => e
              logger.error e
              begin
                client.message(channel: data['channel'], text: e.message) if data.key?('channel')
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
      auth = client.web_client.auth_test
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
