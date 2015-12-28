module SlackRubyBot
  module Commands
    class Default < Base
      command 'about'
      match(/^(?<bot>[[:alnum:][:punct:]@<>]*)$/u)

      def self.call(client, data, _match)
        send_message_with_gif client, data.channel, SlackRubyBot::ABOUT, 'selfie'
      end
    end
  end
end
