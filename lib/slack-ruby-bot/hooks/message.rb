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

      def command_classes(include_slack_ruby_bot = false)
        klasses = SlackRubyBot::Commands::Base.descendants
        klasses.reject! { |k| k.name.starts_with? 'SlackRubyBot::Commands::' } unless include_slack_ruby_bot
        klasses
      end

      def command_to_class(command)
        # prioritize implementations to built-in classes
        klass = command_classes.detect { |d| d.name.ends_with? "::#{command.titleize}" }
        klass ||= command_classes(true).detect { |d| d.name.ends_with? "::#{command.titleize}" }
        klass || SlackRubyBot::Commands::Unknown
      end
    end
  end
end
