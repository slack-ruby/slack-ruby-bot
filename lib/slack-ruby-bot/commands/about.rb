module SlackRubyBot
  module Commands
    class Default < Base
      command 'about'
      match(/^(?<bot>\w*)$/)

      def self.call(data, _match)
        send_message_with_gif data.channel, SlackRubyBot::ABOUT, 'selfie'
      end
    end
  end
end
