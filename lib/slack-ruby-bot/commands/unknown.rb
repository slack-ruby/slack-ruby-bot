module SlackRubyBot
  module Commands
    class Unknown < Base
      match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        return if SlackRubyBot::Config.mute
        client.say(channel: data.channel, text: "Sorry <@#{data.user}>, I don't understand that command!", gif: 'understand')
      end
    end
  end
end
