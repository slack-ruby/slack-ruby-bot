module SlackRubyBot
  module Hooks
    module Hello
      extend Base

      def hello(client, _data)
        logger.info "Successfully connected to #{client.url || 'slack'}."
      end
    end
  end
end
