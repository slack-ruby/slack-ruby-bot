module SlackRubyBot
  module Commands
    class Unknown < Base
      match(/^(?<bot>\w*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        send_message_with_gif client, data.channel, "Sorry <@#{data.user}>, I don't understand that command!", 'idiot'
      end
    end
  end
end
