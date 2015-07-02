module SlackRubyBot
  module Commands
    class Unknown < Base
      def self.call(data, _command, _arguments)
        send_message_with_gif data.channel, "Sorry <@#{data.user}>, I don't understand that command!", 'idiot'
      end
    end
  end
end
