module SlackRubyBot
  module Hooks
    module Hello
      extend Base

      def hello(client, _data)
        return unless client && client.team
        logger.info "Successfully connected to https://#{client.team.domain}.slack.com."
      end
    end
  end
end
