module SlackRubyBot
  module Commands
    class Base
      def self.send_message(channel, text)
        Slack.chat_postMessage(channel: channel, text: text)
      end

      def self.send_message_with_gif(channel, text, keywords)
        gif = begin
          Giphy.random(keywords)
        rescue StandardError => e
          logger.warn "Giphy.random: #{e.message}"
          nil
        end
        text = text + "\n" + gif.image_url.to_s if gif
        send_message channel, text
      end

      def self.logger
        @logger ||= begin
          $stdout.sync = true
          Logger.new(STDOUT)
        end
      end

      def self.responds_to_command?(command)
        name.ends_with? "::#{command.titleize}"
      end
    end
  end
end
