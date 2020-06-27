# frozen_string_literal: true

module SlackRubyBot
  module Hooks
    class Message
      def call(client, data)
        return if !client.allow_message_loops? && client.message_to_self?(data)
        return if !client.allow_bot_messages? && client.bot_message?(data)

        prepare!(data)

        result = child_command_classes.detect { |d| d.invoke(client, data) }
        result ||= built_in_command_classes.detect { |d| d.invoke(client, data) }
        result ||= SlackRubyBot::Commands::Unknown.tap { |d| d.invoke(client, data) }
        result
      end

      private

      def prepare!(data)
        data.text = data.text.strip if data.text
      end

      #
      # All commands.
      #
      # @return [Array] Descendants of SlackRubyBot::Commands::Base.
      #
      def command_classes
        SlackRubyBot::Commands::Base.command_classes
      end

      #
      # All non-built-in, ie. custom commands.
      #
      # @return [Array] Non-built-in descendants of SlackRubyBot::Commands::Base.
      #
      def child_command_classes
        command_classes.reject do |k|
          k.name&.starts_with?('SlackRubyBot::Commands::')
        end
      end

      #
      # All built-in commands.
      #
      # @return [Array] Built-in descendants of SlackRubyBot::Commands::Base.
      #
      def built_in_command_classes
        command_classes.select do |k|
          k.name&.starts_with?('SlackRubyBot::Commands::') && k != SlackRubyBot::Commands::Unknown
        end
      end
    end
  end
end
