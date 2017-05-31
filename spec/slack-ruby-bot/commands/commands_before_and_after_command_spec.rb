require 'spec_helper'

describe SlackRubyBot::Commands do
  def app
    SlackRubyBot::App.new
  end

  before(:all) do
    @klass = Class.new(SlackRubyBot::Commands::Base) do
      class << self
        attr_accessor :executed
      end
      command 'foo' do |client, data, _match|
        self.executed = true
        client.say(channel: data.channel, text: 'foo')
      end
    end
    app
  end

  describe 'with `before` block' do
    after(:each) { @klass.remove_command_hooks }

    it 'runs the global block and the original command block' do
      @flag = false
      @klass.executed = false

      @klass.before do
        @flag = true
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@flag).to be_truthy
      expect(@klass.executed).to be_truthy
    end

    it 'runs global blocks in FIFO order' do
      @order = []

      @klass.before do
        @order << 0
      end

      @klass.before do
        @order << 1
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([0, 1])
    end

    it 'runs the global before block first and the verb-specific block second' do
      @order = []

      @klass.before do
        @order << :global
      end

      @klass.before 'foo' do
        @order << :verb
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([:global, :verb])
    end

    it 'runs the global before block first and the verb-specific block second when defined in flipped order' do
      @order = []

      @klass.before 'foo' do
        @order << :verb
      end

      @klass.before do
        @order << :global
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([:global, :verb])
    end

    it 'runs verb-specific blocks in FIFO order' do
      @order = []

      @klass.before 'foo' do
        @order << 0
      end

      @klass.before 'foo' do
        @order << 1
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([0, 1])
    end

    it 'runs global and verb-specific blocks in FIFO order' do
      @order = []

      @klass.before do
        @order << 0
      end

      @klass.before do
        @order << 1
      end

      @klass.before 'foo' do
        @order << 2
      end

      @klass.before 'foo' do
        @order << 3
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([0, 1, 2, 3])
    end
  end

  describe 'with global `after` block' do
    after(:each) { @klass.remove_command_hooks }

    it 'runs the block and the original command block' do
      @flag = false

      @klass.after do
        @flag = true
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@flag).to be_truthy
      expect(@klass.executed).to be_truthy
    end

    it 'runs global blocks in FIFO order' do
      @order = []

      @klass.after do
        @order << 0
      end

      @klass.after do
        @order << 1
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([0, 1])
    end

    it 'runs the global after block last and the verb-specific block first' do
      @order = []

      @klass.after do
        @order << :global
      end

      @klass.after 'foo' do
        @order << :verb
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([:verb, :global])
    end

    it 'runs the global after block last and the verb-specific block first when defined in flipped order' do
      @order = []

      @klass.after 'foo' do
        @order << :verb
      end

      @klass.after do
        @order << :global
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([:verb, :global])
    end

    it 'runs verb-specific blocks in FIFO order' do
      @order = []

      @klass.after 'foo' do
        @order << 0
      end

      @klass.after 'foo' do
        @order << 1
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([0, 1])
    end

    it 'runs global and verb-specific blocks in FIFO order' do
      @order = []

      @klass.after do
        @order << 2
      end

      @klass.after do
        @order << 3
      end

      @klass.after 'foo' do
        @order << 0
      end

      @klass.after 'foo' do
        @order << 1
      end

      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@order).to eq([0, 1, 2, 3])
    end
  end

  describe '#remove_command_hooks' do
    it 'removes global `before` block and does not run it' do
      @flag = false
      @klass.executed = false

      @klass.before do
        @flag = true
      end

      @klass.remove_command_hooks
      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@flag).to be false
      expect(@klass.executed).to be_truthy
    end

    it 'removes global `after` block and does not run it' do
      @flag = false
      @klass.executed = false

      @klass.after do
        @flag = true
      end

      @klass.remove_command_hooks
      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@flag).to be false
      expect(@klass.executed).to be_truthy
    end

    it 'removes verb-specific `before` block and does not run it' do
      @flag = false
      @klass.executed = false

      @klass.before 'foo' do
        @flag = true
      end

      @klass.remove_command_hooks
      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@flag).to be false
      expect(@klass.executed).to be_truthy
    end

    it 'removes verb-specific `after` block and does not run it' do
      @flag = false
      @klass.executed = false

      @klass.after 'foo' do
        @flag = true
      end

      @klass.remove_command_hooks
      expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
      expect(@flag).to be false
      expect(@klass.executed).to be_truthy
    end

    describe 'with arguments' do
      it 'removes named verb-specific `before` block and does not run it' do
        @flag = false
        @klass.executed = false

        @klass.before 'foo' do
          @flag = true
        end

        @klass.remove_command_hooks(:before, 'foo')
        expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
        expect(@flag).to be false
        expect(@klass.executed).to be_truthy
      end

      it 'removes named verb-specific `before` block and does not run it but leaves global `before` block in place' do
        @flag = false
        @global = false
        @klass.executed = false

        @klass.before 'foo' do
          @flag = true
        end

        @klass.before do
          @global = true
        end

        @klass.remove_command_hooks(:before, 'foo')
        expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
        expect(@flag).to be false
        expect(@global).to be true
        expect(@klass.executed).to be_truthy
      end

      it 'removes named verb-specific `after` block and does not run it' do
        @flag = false
        @klass.executed = false

        @klass.after 'foo' do
          @flag = true
        end

        @klass.remove_command_hooks(:after, 'foo')
        expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
        expect(@flag).to be false
        expect(@klass.executed).to be_truthy
      end

      it 'removes named verb-specific `after` block and does not run it but leaves global `after` block in place' do
        @flag = false
        @global = false
        @klass.executed = false

        @klass.after 'foo' do
          @flag = true
        end

        @klass.after do
          @global = true
        end

        @klass.remove_command_hooks(:after, 'foo')
        expect(message: "#{SlackRubyBot.config.user} foo").to respond_with_slack_message('foo')
        expect(@flag).to be false
        expect(@global).to be true
        expect(@klass.executed).to be_truthy
      end
    end
  end
end
