require 'spec_helper'

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  it_behaves_like 'a slack ruby bot'

  describe '.instance' do
    it 'creates an instance of the App subclass' do
      klass = Class.new(SlackRubyBot::App)
      expect(klass.instance.class).to be klass
    end
  end
end
