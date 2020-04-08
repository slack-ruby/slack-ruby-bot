# frozen_string_literal: true

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  it_behaves_like 'a slack ruby bot'

  describe '.instance' do
    let(:token) { 'slack-api-token' }
    let(:klass) { Class.new(SlackRubyBot::App) }

    before do
      allow(ENV).to receive(:[]).and_call_original.at_least(:once)
    end

    it 'creates an instance of the App subclass' do
      expect(klass.instance.class).to be klass
    end

    context 'when SLACK_API_TOKEN is not defined' do
      it 'raises error' do
        allow(ENV).to receive(:key?).with('SLACK_API_TOKEN').and_return(false)
        SlackRubyBot.configure { |config| config.token = nil }

        expect { klass.instance }.to raise_error RuntimeError, 'Missing Slack API Token.'
      end
    end

    context 'when SLACK_API_TOKEN is defined in ENV but not config' do
      it 'sets config.token from ENV' do
        allow(ENV).to receive(:key?).with('SLACK_API_TOKEN').and_return(true)
        allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(token)
        SlackRubyBot.configure { |config| config.token = nil }

        expect(klass.instance.config.token).to eq(token)
      end
    end

    context 'when SLACK_API_TOKEN is not defined in ENV but is defined in config' do
      it 'sets config.token from config' do
        allow(ENV).to receive(:key?).with('SLACK_API_TOKEN').and_return(false)
        SlackRubyBot.configure { |config| config.token = token }

        expect(klass.instance.config.token).to eq(token)
      end
    end

    context 'when SLACK_API_TOKEN is defined in ENV and config' do
      it 'sets config.token from ENV' do
        token2 = 'another-api-token'
        allow(ENV).to receive(:key?).with('SLACK_API_TOKEN').and_return(true)
        allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(token2)
        SlackRubyBot.configure { |config| config.token = token }

        expect(klass.instance.config.token).to eq(token2)
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
