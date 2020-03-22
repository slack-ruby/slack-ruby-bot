module SlackRubyBot
  module Hooks
    class Hello
      attr_accessor :logger

      def initialize(logger)
        self.logger = logger
        @reconnected = false
      end

      def call(client, _data)
        return unless client && client.team
        logger.info "Successfully #{@reconnected ? 'reconnected' : 'connected'} team #{client.team.name} (#{client.team.id}) to https://#{client.team.domain}.slack.com."
        @reconnected = true
      end
    end
  end
end
