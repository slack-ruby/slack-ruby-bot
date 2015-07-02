module SlackRubyBot
  module Commands
    class Help < Base
      def self.call(data, _command, _arguments)
        send_message_with_gif data.channel, 'See https://github.com/dblock/slack-ruby-bot, please.', 'help'
      end
    end
  end
end
