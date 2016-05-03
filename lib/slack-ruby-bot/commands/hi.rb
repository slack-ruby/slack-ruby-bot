module SlackRubyBot
  module Commands
    class Hi < Base
      title 'hi'
      desc 'Says hello.'
      long_desc 'When a user types "hi" the bot will reply "hello". This helps everyone stay polite.'

      def self.call(client, data, _match)
        client.say(channel: data.channel, text: "Hi <@#{data.user}>!", gif: 'hi')
      end
    end
  end
end
