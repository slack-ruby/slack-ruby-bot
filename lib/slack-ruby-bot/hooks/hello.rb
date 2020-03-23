module SlackRubyBot
  module Hooks
    class Hello
      attr_accessor :logger, :connected_at

      def initialize(logger)
        self.logger = logger
      end

      def call(client, _data)
        return unless client && client.team
        logger.info "Successfully #{@connected_at ? 'reconnected' : 'connected'} team #{client.team.name} (#{client.team.id}) to https://#{client.team.domain}.slack.com."
        self.connected_at ||= Time.now.utc
      end
    end
  end
end
