# frozen_string_literal: true

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  it_behaves_like 'a slack ruby bot'

  describe '.instance' do
    let(:token) { 'slack-api-token' }
    let(:klass) { Class.new(SlackRubyBot::App) }

    it 'creates an instance of the App subclass' do
      expect(klass.instance.class).to be klass
    end

    it 'sets config.token from ENV' do
      expect(klass.instance.config.token).to eq('test')
    end

    context 'when token is not defined' do
      before do
        ENV.delete('SLACK_API_TOKEN')
        SlackRubyBot::Config.token = nil
      end

      it 'raises error' do
        expect { klass.instance }.to raise_error RuntimeError, 'Missing Slack API Token.'
      end
    end

    context 'when token is defined in ENV but not config' do
      before do
        SlackRubyBot::Config.token = nil
      end

      it 'sets config.token from ENV' do
        expect(klass.instance.config.token).to eq('test')
      end
    end

    context 'when token is not defined in ENV but is defined in config' do
      before do
        ENV.delete('SLACK_API_TOKEN')
      end

      it 'sets config.token from config' do
        expect(klass.instance.config.token).to eq('testtoken')
      end
    end

    context 'when aliases are defined in config only' do
      let(:aliases) { %w[alias alias2] }
      before do
        SlackRubyBot::Config.aliases = aliases
      end

      it 'sets config.aliases' do
        expect(klass.instance.config.aliases).to eq(aliases)
      end
    end

    context 'when aliases are defined in ENV only' do
      before do
        ENV['SLACK_RUBY_BOT_ALIASES'] = 'alias3 alias4'
      end
      after do
        ENV.delete('SLACK_RUBY_BOT_ALIASES')
      end

      it 'sets config.aliases from env' do
        expect(klass.instance.config.aliases).to eq(%w[alias3 alias4])
      end
    end
  end

  describe 'executable' do
    it 'can be required as a dependency' do
      response = system("ruby -e \"Bundler = nil ; require 'slack-ruby-bot'\"")
      expect(response).to be true
    end
  end
end
