module SlackRubyBot
  class Server
    include Loggable

    attr_accessor :token, :aliases, :send_gifs

    include SlackRubyBot::Hooks::HookSupport

    TRAPPED_SIGNALS = %w(INT TERM).freeze

    def initialize(options = {})
      @token = options[:token]
      @aliases = options[:aliases]
      @send_gifs = options[:send_gifs]

      # Hook Handling
      flush_hook_blocks

      add_hook_handlers options[:hook_handlers] || {
        hello: SlackRubyBot::Hooks::Hello.new(logger),
        message: SlackRubyBot::Hooks::Message.new
      }
    end

    def run
      loop do
        handle_exceptions do
          handle_signals
          start!
        end
      end
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
      @async ? start_async : start!
    rescue StandardError => e
      case e.message
      when 'account_inactive', 'invalid_auth'
        logger.error "#{token}: #{e.message}, team will be deactivated."
        @stopping = true
      else
        sleep wait
        logger.error "#{e.message}, reconnecting in #{wait} second(s)."
        logger.debug e
        restart! [wait * 2, 60].min
      end
    end

    private

    def handle_exceptions
      yield
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

    def handle_signals
      TRAPPED_SIGNALS.each do |signal|
        Signal.trap(signal) do
          stop!
          exit
        end
      end
    end

    def client
      @client ||= begin
        client = SlackRubyBot::Client.new(aliases: aliases, send_gifs: send_gifs, token: token)
        client.on :close do |_data|
          @client = nil
          restart! unless @stopping
        end
        hooks.client = client

        client
      end
    end
  end
end
