# frozen_string_literal: true

module SlackRubyBot
  module Commands
    class Hi < Base
      help do
        title 'hi'
        desc 'Says hello.'
      end

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: "Hi <@#{data.user}>!")
      end
    end
  end
end
