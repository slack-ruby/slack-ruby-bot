module SlackRubyBot
  class CommandsHelper
    BUILTIN_COMMAND_CLASSES = [SlackRubyBot::Commands::Help, SlackRubyBot::Commands::Hi].freeze
    HELP_ATTR_METHODS_MAP = {
      command_name: :title,
      command_desc: :desc,
      command_long_desc: :long_desc
    }.freeze

    class << self
      def validate_attrs
        all_command_classes.each do |k|
          HELP_ATTR_METHODS_MAP.each do |attr, setter_method|
            raise "#{k}: #{setter_method} is not present" if k.public_send(attr).nil?
          end
        end
      end

      def all_bots_descs
        commands_info(bot_classes).map do |command_info|
          "#{command_name_and_desc(command_info)}\n#{command_info[:long_desc]}"
        end
      end

      def all_commands_descs
        commands_info(command_classes_only).map do |command_info|
          command_name_and_desc(command_info)
        end
      end

      def command_full_desc(name)
        info = commands_info(command_classes_only).find { |command_info| command_info[:title] == name }
        return "There's no command #{name}" unless info
        return "There's no description for command #{name}" if info[:long_desc].blank?
        "#{command_name_and_desc(info)}\n\n#{info[:long_desc]}"
      end

      private

      def command_name_and_desc(command_info)
        desc = command_info[:desc].present? ? "- #{command_info[:desc]}" : ''
        "*#{command_info[:title]}* #{desc}"
      end

      def commands_info(command_classes)
        commands_with_present_names = command_classes.select { |k| k.command_name.present? }
        commands_with_present_names.inject([]) do |data, klass|
          info = {}
          HELP_ATTR_METHODS_MAP.each do |attr, setter_method|
            info[setter_method] = klass.public_send(attr)
          end
          data << info
        end
      end

      def bot_classes
        all_command_classes.select { |k| k.superclass == SlackRubyBot::Bot }
      end

      def command_classes_only
        all_command_classes.reject { |k| k.superclass == SlackRubyBot::Bot  }
      end

      def all_command_classes
        BUILTIN_COMMAND_CLASSES + external_command_classes
      end

      def command_classes
        SlackRubyBot::Commands::Base.descendants
      end

      def external_command_classes
        command_classes.reject do |k|
          k.name && k.name.start_with?('SlackRubyBot::Commands') || k == SlackRubyBot::Bot
        end
      end
    end
  end
end
