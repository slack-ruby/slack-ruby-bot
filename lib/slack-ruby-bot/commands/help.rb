# frozen_string_literal: true

module SlackRubyBot
  module Commands
    class Help < Base
      help do
        title 'help'
        desc 'Shows help information.'
      end

      command 'help' do |client, data, match|
        command = match[:expression]

        text = if command.present?
                 Support::Help.instance.command_full_desc(command)
               else
                 general_text
               end

        client.say(channel: data.channel, text: text)
      end

      class << self
        private

        def general_text
          bot_desc = Support::Help.instance.bot_desc_and_commands
          other_commands_descs = Support::Help.instance.other_commands_descs
          <<~TEXT
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
