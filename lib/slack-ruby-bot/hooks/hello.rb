# frozen_string_literal: true

module SlackRubyBot
  module Hooks
    class Hello
      attr_accessor :logger, :connected_at

      def initialize(logger)
        self.logger = logger
      end

      def call(client, _data)
        return unless client&.team

        new_connected_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        log = [
          'Successfully',
          connected_at ? 'reconnected' : 'connected',
          "team #{client.team.name} (#{client.team.id}) to https://#{client.team.domain}.slack.com",
          connected_at ? "after #{last_connection_till(new_connected_at)}s" : nil
        ].compact.join(' ') + '.'

        logger.info log

        self.connected_at = new_connected_at
      end

      private

      def last_connection_till(time)
        (time - connected_at).round(2)
      end
    end
  end
end
