module SlackRubyBot
  module Commands
    class Help < Base
      def self.call(client, data, _match)
        client.say(channel: data.channel, text: 'See https://github.com/dblock/slack-ruby-bot, please.', gif: 'help')
      end
    end
  end
end
