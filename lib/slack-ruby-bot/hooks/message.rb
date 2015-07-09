module SlackRubyBot
  module Hooks
    module Message
      extend Base

      def message(data)
        data = Hashie::Mash.new(data)
        bot_name, command, arguments = parse_command(data.text)
        return unless bot_name == SlackRubyBot.config.user
        klass = command_to_class(command || 'Default')
        klass.call data, command, arguments
      end

      private

      def parse_command(text)
        return unless text
        parts = text.split.reject(&:blank?)
        [parts.first.downcase, parts[1].try(:downcase), parts[2..parts.length]] if parts && parts.any?
      end

      def command_classes
        @command_classes ||= SlackRubyBot::Commands::Base.descendants.reject do |k|
          k.name.starts_with? 'SlackRubyBot::Commands::'
        end
      end

      def built_in_command_classes
        @built_in_command_classes ||= SlackRubyBot::Commands::Base.descendants.select do |k|
          k.name.starts_with? 'SlackRubyBot::Commands::'
        end
      end

      def command_to_class(command)
        # prioritize implementations to built-in classes
        klass = command_classes.detect { |d| d.responds_to_command?(command) }
        klass ||= built_in_command_classes.detect { |d| d.responds_to_command?(command) }
        klass || SlackRubyBot::Commands::Unknown
      end
    end
  end
end
