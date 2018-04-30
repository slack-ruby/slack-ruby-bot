# frozen_string_literal: true

describe SlackRubyBot::Commands::Base do
  let! :command1 do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'command'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  let! :command2 do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'command'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  def app
    SlackRubyBot::App.new
  end

  describe '#command_classes' do
    it 'returns all registered command classes' do
      expect(SlackRubyBot::Commands::Base.command_classes).to include command1
      expect(SlackRubyBot::Commands::Base.command_classes).to include command2
    end

    it 'returns command1 before command2' do
      command_classes = SlackRubyBot::Commands::Base.command_classes
      expect(command_classes.find_index(command1)).to be < command_classes.find_index(command2)
    end

    it 'uses the object_id of an anonymous class as the default command name' do
      command_classes = SlackRubyBot::Commands::Base.command_classes
      anon_class = Class.new(SlackRubyBot::Commands::Base)
      expect(command_classes).to include anon_class
      expect(command_classes.find { |obj| obj == anon_class }.object_id.to_s).to eq anon_class.command_name_from_class
    end
  end
end
