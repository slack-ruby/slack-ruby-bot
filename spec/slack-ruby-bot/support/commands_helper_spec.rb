require 'spec_helper'

describe SlackRubyBot::CommandsHelper do
  let(:bot_class_name) { 'Testing::WeatherBot' }
  let(:command_class_name) { 'Testing::HelloCommand' }
  let(:commands_helper) { described_class.instance }

  describe '#capture_help' do
    let(:help_attrs) { commands_helper.commands_help_attrs }
    let(:bot_help_attrs) { help_attrs.find { |k| k.class_name == bot_class_name } }
    let(:command_help_attrs) { help_attrs.find { |k| k.class_name == command_class_name } }

    it 'should save bot class name' do
      expect(bot_help_attrs).to be
    end

    describe 'captures help attributes correctly' do
      context 'for command' do
        it 'command name' do
          expect(command_help_attrs.command_name).to eq('hello')
        end

        it 'command description' do
          expect(command_help_attrs.command_desc).to eq('Says hello.')
        end

        it 'command long description' do
          expect(command_help_attrs.command_long_desc).to eq('The long description')
        end
      end

      context 'for bot' do
        it 'name' do
          expect(bot_help_attrs.command_name).to eq('Weather Bot')
        end

        it 'description' do
          expect(bot_help_attrs.command_desc).to eq('This bot tells you the weather.')
        end

        describe 'commands' do
          let(:clouds_command) { bot_help_attrs.commands.find { |k| k.command_name == 'clouds' } }
          let(:weather_command) { bot_help_attrs.commands.find { |k| k.command_name == "What's the weather in <city>?" } }

          it 'command name' do
            expect(clouds_command).to be
            expect(weather_command).to be
          end

          it 'command description' do
            expect(clouds_command.command_desc).to eq("Tells you how many clouds there're above you.")
            expect(weather_command.command_desc).to eq('Tells you the weather in a <city>.')
          end

          it 'command long description' do
            expect(weather_command.command_long_desc).to eq("Accurate 10 Day Weather Forecasts for thousands of places around the World.\n" \
                                                            'We provide detailed Weather Forecasts over a 10 day period updated four times a day.')
          end
        end
      end
    end
  end

  describe '#bot_desc_and_commands' do
    let(:bot_desc) { commands_helper.bot_desc_and_commands.first }

    it 'returns bot name and description' do
      expect(bot_desc).to include('*Weather Bot* - This bot tells you the weather.')
    end

    it 'returns possible commands for bot' do
      expect(bot_desc).to include("\n\n*Commands:*\n")
      expect(bot_desc).to include("*clouds* - Tells you how many clouds there're above you.\n")
      expect(bot_desc).to include("*What's the weather in <city>?* - Tells you the weather in a <city>.")
    end

    it 'do not return command with empty name' do
      expect(bot_desc).to_not include('**')
    end

    it 'do not show description for command without description' do
      expect(bot_desc).to include("*command_without_description*\n")
    end
  end

  describe '#other_commands_descs' do
    let(:commands_desc) { commands_helper.other_commands_descs }
    let(:hello_command_desc) { commands_desc.find { |desc| desc =~ /\*hello\*/ } }

    it 'returns command name and description' do
      expect(hello_command_desc).to eq('*hello* - Says hello.')
    end
  end

  describe '#command_full_desc' do
    context 'for bot commands' do
      it 'returns long description' do
        full_desc = commands_helper.command_full_desc("What's the weather in &lt;city&gt;?")
        expect(full_desc).to include "Accurate 10 Day Weather Forecasts for thousands of places around the World.\n" \
          'We provide detailed Weather Forecasts over a 10 day period updated four times a day.'
      end
    end

    context 'for other commands' do
      it 'returns long description' do
        full_desc = commands_helper.command_full_desc('hello')
        expect(full_desc).to include 'The long description'
      end
    end

    it 'returns correct message if there is no such command' do
      full_desc = commands_helper.command_full_desc('deploy')
      expect(full_desc).to eq "There's no command *deploy*"
    end

    it 'returns correct message if there is no long description for the command' do
      full_desc = commands_helper.command_full_desc('clouds')
      expect(full_desc).to eq "There's no description for command *clouds*"
    end
  end
end
