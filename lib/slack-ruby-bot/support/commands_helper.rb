require 'singleton'

module SlackRubyBot
  class CommandHelpAttrs
    attr_accessor :command_name, :command_desc, :command_long_desc
    attr_reader :class_name, :commands

    def initialize(class_name)
      @class_name = class_name
      @commands = []
    end

    def title(title)
      self.command_name = title
    end

    def desc(desc)
      self.command_desc = desc
    end

    def long_desc(long_desc)
      self.command_long_desc = long_desc
    end

    def command(title, &block)
      @commands << self.class.new(class_name).tap { |k| k.title(title); k.instance_eval &block }
    end
  end

  class CommandsHelper
    include Singleton
    attr_reader :commands_help_attrs

    def initialize
      @commands_help_attrs = []
    end

    def capture_help(class_name, &block)
      k = CommandHelpAttrs.new(class_name)
      k.instance_eval(&block)
      @commands_help_attrs << k
    end

    def bot_desc_and_commands
      collect_help_attrs(bot_help_attrs) do |help_attrs|
        bot_commands_descs = collect_name_and_desc(help_attrs.commands)
        "#{command_name_and_desc(help_attrs)}\n\n*Commands:*\n#{bot_commands_descs.join("\n")}"
      end
    end

    def other_commands_descs
      collect_name_and_desc(other_commands_help_attrs)
    end

    def command_full_desc(name)
      unescaped_name = CGI.unescapeHTML(name)
      help_attrs = find_command_help_attrs(unescaped_name)
      return "There's no command *#{unescaped_name}*" unless help_attrs
      return "There's no description for command *#{unescaped_name}*" if help_attrs.command_long_desc.blank?
      "#{command_name_and_desc(help_attrs)}\n\n#{help_attrs.command_long_desc}"
    end

    private

    def find_command_help_attrs(name)
      help_attrs = commands_help_attrs.find { |k| k.command_name == name }
      return help_attrs if help_attrs
      commands_help_attrs.each { |k| k.commands.each { |c| return c if c.command_name == name } }
      return nil
    end

    def collect_help_attrs(help_attrs)
      help_attrs_with_present_names(help_attrs).map do |help_attrs|
        yield(help_attrs)
      end
    end

    def collect_name_and_desc(help_attrs)
      collect_help_attrs(help_attrs) do |help_attrs|
        command_name_and_desc(help_attrs)
      end
    end

    def command_name_and_desc(help_attrs)
      desc = help_attrs.command_desc.present? ? "- #{help_attrs.command_desc}" : ''
      "*#{help_attrs.command_name}* #{desc}"
    end

    def help_attrs_with_present_names(help_attrs)
      help_attrs.select { |k| k.command_name.present? }
    end

    def bot_help_attrs
      commands_help_attrs.select { |k| k.class_name.constantize.superclass == SlackRubyBot::Bot }
    end

    def other_commands_help_attrs
      commands_help_attrs.select { |k| k.class_name.constantize.superclass == SlackRubyBot::Commands::Base }
    end

  end
end
