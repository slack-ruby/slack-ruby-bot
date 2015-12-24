module SlackRubyBot
  class Server
    cattr_accessor :hooks
    attr_accessor :token

    include SlackRubyBot::Hooks::Hello
    include SlackRubyBot::Hooks::Message

    def initialize(options = {})
      @token = options[:token]
    end

    def run
      auth!
      loop do
        begin
          start!
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

    def auth!
      client.auth = client.web_client.auth_test
      logger.info "Welcome '#{client.auth['user']}' to the '#{client.auth['team']}' team at #{client.auth['url']}."
    end

    def start!
      @stopping = false
      @async = false
      client.start!
    end

    def start_async
      @stopping = false
      @async = true
      client.start_async
    end

    def stop!
      @stopping = true
      client.stop! if @client
    end

    def restart!(wait = 1)
      if @async
        start_async
      else
        start!
      end
    rescue StandardError => e
      sleep wait
      logger.error "#{e.message}, reconnecting in #{wait} second(s)."
      logger.debug e
      restart! [wait * 2, 60].min
    end

    private

    def logger
      @logger ||= begin
        $stdout.sync = true
        Logger.new(STDOUT)
      end
    end

    def client
      @client ||= begin
        client = SlackRubyBot::Client.new(token: token)
        client.on :close do |_data|
          @client = nil
          restart! unless @stopping
        end
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
  end
end
