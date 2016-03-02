require 'spec_helper'

describe SlackRubyBot::Hooks::HookSupport do
  subject do
    Class.new do
      include SlackRubyBot::Hooks::HookSupport

      on 'hello' do |_ = nil, _ = nil|
        'hello'
      end

      on 'hello' do |_ = nil, _ = nil|
        'hello-2'
      end

      on 'goodbye' do |_ = nil, _ = nil|
        'goodbye'
      end
    end
  end

  describe 'hook code blocks' do
    it "let's you define class level code blocks" do
      expect(subject.hook_blocks.size).to eq(2)
      expect(subject.hook_blocks.keys).to eq %w(hello goodbye)

      expect(subject.hook_blocks['hello'].size).to eq(2)
      expect(subject.hook_blocks['goodbye'].size).to eq(1)

      expect(subject.hook_blocks['hello'].first.call).to eq('hello')
      expect(subject.hook_blocks['hello'].last.call).to eq('hello-2')
      expect(subject.hook_blocks['goodbye'].last.call).to eq('goodbye')
    end
  end

  describe '#flush_hook_blocks' do
    it 'registers class hook blocks as hook handlers in set' do
      object = subject.new

      expect(object.hooks).to receive(:add).exactly(3).times.and_call_original

      expect do
        object.flush_hook_blocks
      end.to change { object.hooks.handlers.size }.by(2)
    end
  end
end
