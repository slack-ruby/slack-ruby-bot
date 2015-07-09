module SlackRubyBot
  module Commands
    class Base
      class_attribute :operators
      class_attribute :commands

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
        commands ? commands.include?(command) : command == default_command_name
      end

      def self.default_command_name
        name && name.split(':').last.downcase
      end

      def self.responds_to_operator?(operator)
        operators && operators.include?(operator)
      end

      def self.operator(value)
        self.operators ||= []
        self.operators << value.to_s
      end

      def self.command(value)
        self.commands ||= []
        self.commands << value.to_s
      end
    end
  end
end
