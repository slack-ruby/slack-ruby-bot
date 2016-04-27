module SlackRubyBot
  module Commands
    class Commands < Base
      BUILTIN_COMMAND_CLASSES = [SlackRubyBot::Commands::Help, SlackRubyBot::Commands::Hi].freeze

      class << self
        def call(client, data, _match)
          commands = (BUILTIN_COMMAND_CLASSES + external_command_classes).map { |c| c.routes.keys }.flatten
          client.say(channel: data.channel, text: "*Possible commands:*\n#{commands.join("\n")}")
        end

        private

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
end
