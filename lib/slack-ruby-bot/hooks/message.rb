# frozen_string_literal: true

module SlackRubyBot
  module Hooks
    class Message
      def call(client, data)
        return if message_to_self_not_allowed? && message_to_self?(client, data)
        return if bot_message_not_allowed? && bot_message?(client, data)

        data.text = data.text.strip.gsub("\u00A0", ' ') if data.text
        result = child_command_classes.detect { |d| d.invoke(client, data) }
        result ||= built_in_command_classes.detect { |d| d.invoke(client, data) }
        result ||= SlackRubyBot::Commands::Unknown.tap { |d| d.invoke(client, data) }
        result
      end

      private

      def message_to_self_not_allowed?
        !SlackRubyBot::Config.allow_message_loops?
      end

      def message_to_self?(client, data)
        client.self && client.self.id == data.user
      end

      def bot_message_not_allowed?
        !SlackRubyBot::Config.allow_bot_messages?
      end

      def bot_message?(_client, data)
        data.subtype == 'bot_message'
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
