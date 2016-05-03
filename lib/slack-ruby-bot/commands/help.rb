module SlackRubyBot
  module Commands
    class Help < Base
      title 'help'
      desc 'Shows help information.'
      long_desc ''

      command 'help' do |client, data, match|
        command = match[:expression]

        text = if command.present?
                 CommandsHelper.command_full_desc(command)
               else
                 general_text
               end

        client.say(channel: data.channel, text: text, gif: 'help')
      end

      class << self

        private

        def general_text
          bots_descs = CommandsHelper.all_bots_descs
          command_descs = CommandsHelper.all_commands_descs
          <<TEXT
#{bots_descs.join("\n")}

*Possible commands:*
#{command_descs.join("\n")}

For getting description of the command use: *help <command>*

For more information see https://github.com/dblock/slack-ruby-bot, please.
TEXT
        end

      end
    end
  end
end
