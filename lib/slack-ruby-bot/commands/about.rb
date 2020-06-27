# frozen_string_literal: true

module SlackRubyBot
  module Commands
    class Default < Base
      command 'about'
      match(/^#{bot_matcher}$/u)

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: SlackRubyBot::ABOUT)
      end
    end
  end
end
