# frozen_string_literal: true

describe SlackRubyBot::Hooks::Message do
  let(:message_hook) { described_class.new }

  describe '#call' do
    it 'doesn\'t raise an error when message is a frozen string' do
      expect do
        message_hook.call(
          SlackRubyBot::Client.new,
          Hashie::Mash.new(text: 'message'.freeze) # rubocop:disable Style/RedundantFreeze
        )
      end.to_not raise_error
    end
  end

  describe '#child_command_classes' do
    it 'returns only child command classes' do
      child_command_classes = message_hook.send(:child_command_classes)
      expect(child_command_classes).to include SlackRubyBot::Bot
      expect(child_command_classes).to_not include SlackRubyBot::Commands::Hi
    end
  end

  describe '#built_in_command_classes' do
    let(:built_in_command_classes) { message_hook.send(:built_in_command_classes) }
    it 'returns only built in command classes' do
      expect(built_in_command_classes).to include SlackRubyBot::Commands::Hi
      expect(built_in_command_classes).to include SlackRubyBot::Commands::Default
      expect(built_in_command_classes).to include SlackRubyBot::Commands::Help
      expect(built_in_command_classes).to_not include SlackRubyBot::Bot
    end
    it 'does not return unknown command class' do
      expect(built_in_command_classes).to_not include SlackRubyBot::Commands::Unknown
    end
  end
  describe '#message' do
    let(:client) { Hashie::Mash.new(self: { 'id' => 'U0K8CKKT1' }) }
    it 'invokes a command' do
      expect(SlackRubyBot::Commands::Unknown).to receive(:invoke)
      message_hook.call(client, Hashie::Mash.new(user: 'U0K8CKKT2'))
    end
  end
end
