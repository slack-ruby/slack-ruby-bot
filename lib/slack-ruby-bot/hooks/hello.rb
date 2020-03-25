module SlackRubyBot
  module Hooks
    class Hello
      attr_accessor :logger, :connected_at

      def initialize(logger)
        self.logger = logger
      end

      def call(client, _data)
        return unless client && client.team
        log = ["Successfully #{@connected_at ? 'reconnected' : 'connected'} team #{client.team.name} (#{client.team.id}) to https://#{client.team.domain}.slack.com"]

        connected_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        log << "after #{(connected_at - self.connected_at).round(2)}s" if self.connected_at

        puts log
        logger.info "#{log.join(' ')}."

        self.connected_at = connected_at
      end
    end
  end
end
