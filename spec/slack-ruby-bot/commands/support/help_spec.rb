# frozen_string_literal: true

describe SlackRubyBot::Commands::Support::Help do
  let(:bot_class) { Testing::WeatherBot }
  let(:command_class) { Testing::HelloCommand }
  let(:help) { described_class.instance }

  describe '#capture_help' do
    let(:help_attrs) { help.commands_help_attrs }
    let(:bot_help_attrs) { help_attrs.find { |k| k.klass == bot_class } }
    let(:command_help_attrs) { help_attrs.find { |k| k.klass == command_class } }

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

  describe '#find_command_help_attrs' do
    let(:hello_help_attrs) { help.find_command_help_attrs('hello') }

    before(:each) do
      command_class
    end

    it 'returns help attrs for hello command' do
      expect(hello_help_attrs.command_name).to eq('hello')
      expect(hello_help_attrs.command_desc).to eq('Says hello.')
      expect(hello_help_attrs.command_long_desc).to eq('The long description')
    end
  end

  describe '#bot_desc_and_commands' do
    let(:bot_desc_and_commands) { help.bot_desc_and_commands }
    let(:bot_desc) { bot_desc_and_commands.first }

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

    context 'subclasses' do
      let(:another_bot_base) { Class.new(SlackRubyBot::Bot) }
      let!(:another_bot) do
        Class.new(another_bot_base) do
          help do
            title 'Creating your own base class works too!'
          end
        end
      end

      it 'expose help commands' do
        expect(bot_desc_and_commands).to include("*Creating your own base class works too!*\n\n*Commands:*\n")
      end
    end
  end

  describe '#other_commands_descs' do
    let(:another_command_base) { Class.new(SlackRubyBot::Commands::Base) }
    let!(:another_command) do
      Class.new(another_command_base) do
        help do
          title 'Creating your own base class works too!'
        end
      end
    end

    let(:other_commands_descs) { help.other_commands_descs }
    let(:hello_command_desc) { other_commands_descs.find { |desc| desc =~ /\*hello\*/ } }

    it 'returns command name and description' do
      expect(hello_command_desc).to eq('*hello* - Says hello.')
    end

    it 'includes commands who do not directly inherit from provided base class' do
      expect(other_commands_descs).to include('*Creating your own base class works too!*')
    end
  end

  describe '#command_full_desc' do
    context 'for bot commands' do
      it 'returns long description' do
        full_desc = help.command_full_desc("What's the weather in &lt;city&gt;?")
        expect(full_desc).to include "Accurate 10 Day Weather Forecasts for thousands of places around the World.\n" \
          'We provide detailed Weather Forecasts over a 10 day period updated four times a day.'
      end
    end

    context 'for other commands' do
      it 'returns long description' do
        full_desc = help.command_full_desc('hello')
        expect(full_desc).to include 'The long description'
      end
    end

    it 'returns correct message if there is no such command' do
      full_desc = help.command_full_desc('deploy')
      expect(full_desc).to eq "There's no command *deploy*"
    end

    it 'returns correct message if there is no long description for the command' do
      full_desc = help.command_full_desc('clouds')
      expect(full_desc).to eq "There's no description for command *clouds*"
    end
  end
end
