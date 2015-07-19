module SlackRubyBot
  module Commands
    class Base
      class_attribute :operators
      class_attribute :commands

      def self.send_message(channel, text, options = { as_user: true })
        if text && text.length > 0
          chat_postMessage({ channel: channel, text: text }.merge(options))
        else
          send_message_with_gif channel, 'Nothing to see here.', 'nothing', options
        end
      end

      def self.send_message_with_gif(channel, text, keywords, options = { as_user: true })
        gif = begin
          Giphy.random(keywords)
        rescue StandardError => e
          logger.warn "Giphy.random: #{e.message}"
          nil
        end
        text = text + "\n" + gif.image_url.to_s if gif
        send_message channel, text, options
      end

      def self.logger
        @logger ||= begin
          $stdout.sync = true
          Logger.new(STDOUT)
        end
      end

      def self.responds_to_command?(command)
        commands ? commands.keys.include?(command) : command == default_command_name
      end

      def self.default_command_name
        name && name.split(':').last.downcase
      end

      def self.responds_to_operator?(operator)
        operators && operators.keys.include?(operator)
      end

      def self.operator(*values, &block)
        self.operators ||= {}
        values.each do |value|
          self.operators[value] = block
        end
      end

      def self.command(*values, &block)
        self.commands ||= {}
        values.each do |value|
          self.commands[value] = block
        end
      end

      def self.invoke(data, command, arguments)
        method = self.commands[command] if self.commands
        method ||= self.operators[command] if self.operators
        if method
          method.call(data, command, arguments)
        elsif self.respond_to?(:call)
          send :call, data, command, arguments
        else
          fail NotImplementedError, command
        end
      end

      private

      def self.chat_postMessage(message)
        Slack.chat_postMessage(message)
      end
    end
  end
end
