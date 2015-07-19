module SlackRubyBot
  module Hooks
    module Message
      extend Base

      def message(data)
        data = Hashie::Mash.new(data)
        klass, command, arguments = text_to_class(data.text)
        return unless klass
        klass.invoke(data, command, arguments)
      end

      private

      #
      # Lookup a class that can execute a command or an operator.
      #
      # @param [String] text Free-formed text from Slack.
      #
      # @return [SlackRubyBot::Commands::Base] A child class of SlackRubyBot::Commands::Base.
      #
      def text_to_class(text)
        return unless text
        command, arguments = parse_command(text)
        if command
          [command_to_class(command) || SlackRubyBot::Commands::Unknown, command, arguments]
        else
          command, arguments = parse_operator(text)
          [operator_to_class(command), command, arguments]
        end
      end

      #
      # Split text into a command and its arguments.
      #
      # @param [String] text Free-formed text from Slack, eg. `bot do something`.
      #
      # @return [Array] An array of command and arguments or nil.
      #
      def parse_command(text)
        return unless text
        parts = text.split.reject(&:blank?)
        return unless parts && parts.any?
        # command is [bot] <command> (argument1, ...)
        bot_or_operator = parts.first.downcase
        return unless SlackRubyBot.config.user == bot_or_operator
        command = parts[1].try(:downcase) || 'default'
        arguments = parts[2..parts.length]
        [command, arguments]
      end

      #
      # Split text into an operator and its arguments.
      #
      # @param [String] text Free-formed text from Slack, eg. =2+2.
      #
      # @return [Array] An array and arguments or nil.
      #
      def parse_operator(text)
        return unless text && text.length > 0
        [text[0], text[1..text.length].split.reject(&:blank?)]
      end

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
          k.name && k.name.starts_with?('SlackRubyBot::Commands::')
        end
      end

      #
      # Converts a command to a class.
      #
      # @param [String] command Command tet.
      #
      # @return [SlackRubyBot::Commands::Base] A command implementation.
      #
      def command_to_class(command)
        # prioritize implementations to built-in classes
        klass = child_command_classes.detect { |d| d.responds_to_command?(command) }
        klass ||= built_in_command_classes.detect { |d| d.responds_to_command?(command) }
        klass
      end

      #
      # Converts an operator to a class.
      #
      # @param [String] operator Operator text.
      #
      # @return [<type>] An operator implementation.
      #
      def operator_to_class(operator)
        command_classes.detect do |k|
          k.responds_to_operator?(operator)
        end
      end
    end
  end
end
