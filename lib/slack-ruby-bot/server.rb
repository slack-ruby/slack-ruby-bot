# frozen_string_literal: true

module SlackRubyBot
  class Server
    include Loggable

    attr_accessor :token, :aliases

    include SlackRubyBot::Hooks::HookSupport

    TRAPPED_SIGNALS = %w[INT TERM].freeze

    def initialize(options = {})
      @token = options[:token]
      @aliases = options[:aliases]

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
      client.start!
    end

    def start_async
      client.start_async
    end

    def stop!
      client.stop! if @client
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
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed, Faraday::SSLError => e
      logger.error e
      sleep 1 # ignore, try again
    rescue StandardError => e
      logger.error e.message
      logger.error e.backtrace.join("\n")
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
        client = SlackRubyBot::Client.new(aliases: aliases, token: token)
        _hooks.client = client

        client
      end
    end
  end
end
