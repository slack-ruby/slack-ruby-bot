module SlackRubyBot
  class Server
    include Loggable
    cattr_accessor :hooks
    attr_accessor :token, :aliases, :send_gifs

    TRAPPED_SIGNALS = %w(INT TERM).freeze

    include SlackRubyBot::Hooks::Hello
    include SlackRubyBot::Hooks::Message

    def initialize(options = {})
      @token = options[:token]
      @aliases = options[:aliases]
      @send_gifs = options.key?(:send_gifs) ? !!options[:send_gifs] : true
    end

    def run
      loop do
        handle_execeptions do
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

    def hello!
      return unless client.self && client.team
      logger.info "Welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
    end

    def restart!(wait = 1)
      @async ? start_async : start!
    rescue StandardError => e
      sleep wait
      logger.error "#{e.message}, reconnecting in #{wait} second(s)."
      logger.debug e
      restart! [wait * 2, 60].min
    end

    private

    def handle_execeptions
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
        client.on :hello do
          hello!
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
