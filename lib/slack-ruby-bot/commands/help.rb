module SlackRubyBot
  module Commands
    class Help < Base
      def self.call(client, data, _match)
        send_message_with_gif client, data.channel, 'See https://github.com/dblock/slack-ruby-bot, please.', 'help'
      end
    end
  end
end
