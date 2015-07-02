module SlackRubyBot
  module Commands
    class Hi < Base
      def self.call(data, _command, _arguments)
        send_message_with_gif data.channel, "Hi <@#{data.user}>!", 'hi'
      end
    end
  end
end
