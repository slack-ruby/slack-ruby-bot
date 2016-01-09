module SlackRubyBot
  module Commands
    class Hi < Base
      def self.call(client, data, _match)
        client.say(channel: data.channel, text: "Hi <@#{data.user}>!", gif: 'hi')
      end
    end
  end
end
