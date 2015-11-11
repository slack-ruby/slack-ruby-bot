module SlackRubyBot
  class Server
    cattr_accessor :hooks
    attr_accessor :auth
    attr_accessor :token

    include SlackRubyBot::Hooks::Hello
    include SlackRubyBot::Hooks::Message

    def initialize(options = {})
      @token = options[:token]
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
        client = Slack::RealTime::Client.new(token: token)
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
      @auth = client.web_client.auth_test
      logger.info "Welcome '#{auth['user']}' to the '#{auth['team']}' team at #{auth['url']}."
    end

    def reset!
      @auth = nil
    end
  end
end
