module SlackRubyBot
  module Commands
    class HelpCommand < Base
      help do
        title 'help'
        desc 'Shows help information.'
      end

      command 'help' do |client, data, match|
        command = match[:expression]

        text = if command.present?
                 CommandsHelper.instance.command_full_desc(command)
               else
                 general_text
               end

        client.say(channel: data.channel, text: text, gif: 'help')
      end

      class << self
        private

        def general_text
          bot_desc = CommandsHelper.instance.bot_desc_and_commands
          other_commands_descs = CommandsHelper.instance.other_commands_descs
          <<TEXT
#{bot_desc.join("\n")}

*Other commands:*
#{other_commands_descs.join("\n")}

For getting description of the command use: *help <command>*

For more information see https://github.com/slack-ruby/slack-ruby-bot, please.
TEXT
        end
      end
    end
  end
end
