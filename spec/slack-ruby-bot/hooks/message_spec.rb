# frozen_string_literal: true

describe SlackRubyBot::Hooks::Message do
  let(:message_hook) { described_class.new }

  describe '#call' do
    it 'doesn\'t raise an error when message is a frozen string' do
      message_hook.call(
        SlackRubyBot::Client.new,
        Hashie::Mash.new(text: 'message')
      )
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
    it 'calls the correct command when no-break space present' do
      client = respond_to?(:client) ? send(:client) : SlackRubyBot::Client.new
      message_command = SlackRubyBot::Hooks::Message.new
      allow(client).to(receive(:message)) do |options|
        @messages ||= []
        @messages.push(options)
      end

      run_command = message_command.call(
        client, Hashie::Mash.new(text: "#{SlackRubyBot.config.user}\u00a0help", channel: 'channel')
      )

      expect(run_command).to(eq(SlackRubyBot::Commands::Help))
    end
  end
  describe '#message_to_self_not_allowed?' do
    context 'with allow_message_loops set to true' do
      before do
        SlackRubyBot::Config.allow_message_loops = true
      end
      it do
        expect(message_hook.send(:message_to_self_not_allowed?)).to be false
      end
    end
    context 'with allow_message_loops set to false' do
      before do
        SlackRubyBot::Config.allow_message_loops = false
      end
      it do
        expect(message_hook.send(:message_to_self_not_allowed?)).to be true
      end
    end
  end
  describe '#bot_message_not_allowed?' do
    context 'with allow_bot_messages set to true' do
      before do
        SlackRubyBot::Config.allow_bot_messages = true
      end
      it do
        expect(message_hook.send(:bot_message_not_allowed?)).to be false
      end
    end
    context 'with allow_bot_messages set to false' do
      before do
        SlackRubyBot::Config.allow_bot_messages = false
      end
      it do
        expect(message_hook.send(:bot_message_not_allowed?)).to be true
      end
    end
  end
  describe '#message_to_self?' do
    let(:client) { Hashie::Mash.new(self: { 'id' => 'U0K8CKKT1' }) }
    context 'with message to self' do
      it do
        expect(message_hook.send(:message_to_self?, client, Hashie::Mash.new(user: 'U0K8CKKT1'))).to be true
      end
    end
    context 'with message to another user' do
      it do
        expect(message_hook.send(:message_to_self?, client, Hashie::Mash.new(user: 'U0K8CKKT2'))).to be false
      end
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
