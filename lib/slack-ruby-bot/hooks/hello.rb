module SlackRubyBot
  module Hooks
    class Hello
      attr_accessor :logger
      attr_accessor :connected_at

      def initialize(logger)
        self.logger = logger
      end

      def call(client, _data)
        return unless client && client.team
        return if connected_at
        logger.info "Successfully connected team #{client.team.name} (#{client.team.id}) to https://#{client.team.domain}.slack.com."
        @connected_at = Time.now.utc
      end
    end
  end
end
