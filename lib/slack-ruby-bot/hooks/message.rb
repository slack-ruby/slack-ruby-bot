module SlackRubyBot
  module Hooks
    module Message
      extend Base

      def message(data)
        data = Hashie::Mash.new(data)
        data.text.strip! if data.text
        result = child_command_classes.detect { |d| d.invoke(data) }
        result ||= built_in_command_classes.detect { |d| d.invoke(data) }
        result ||= SlackRubyBot::Commands::Unknown.tap { |d| d.invoke(data) }
        result
      end

      private

      #
      # All commands.
      #
      # @return [Array] Descendants of SlackRubyBot::Commands::Base.
      #
      def command_classes
        SlackRubyBot::Commands::Base.descendants
      end

      #
      # All non-built-in, ie. custom commands.
      #
      # @return [Array] Non-built-in descendants of SlackRubyBot::Commands::Base.
      #
      def child_command_classes
        command_classes.reject do |k|
          k.name && k.name.starts_with?('SlackRubyBot::Commands::')
        end
      end

      #
      # All built-in commands.
      #
      # @return [Array] Built-in descendants of SlackRubyBot::Commands::Base.
      #
      def built_in_command_classes
        command_classes.select do |k|
          k.name && k.name.starts_with?('SlackRubyBot::Commands::') && k != SlackRubyBot::Commands::Unknown
        end
      end
    end
  end
end
