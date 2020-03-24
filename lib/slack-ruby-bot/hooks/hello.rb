module SlackRubyBot
  module Hooks
    class Hello
      attr_accessor :logger, :connected_at

      def initialize(logger)
        self.logger = logger
      end

      def call(client, _data)
        return unless client && client.team
        log = "Successfully #{@connected_at ? 'reconnected' : 'connected'} team #{client.team.name} (#{client.team.id}) to https://#{client.team.domain}.slack.com."

        connected_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        log << " Time elapsed since last connection: #{connected_at - self.connected_at} seconds." if self.connected_at

        logger.info log

        self.connected_at = connected_at
      end
    end
  end
end
