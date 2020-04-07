# frozen_string_literal: true

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  it_behaves_like 'a slack ruby bot'

  describe '.initialize' do
    let(:token) { 'slack-api-token' }

    it 'sets config.token' do
      allow(ENV).to receive(:[]).and_call_original.at_least(:once)
      allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(token)

      expect(app.config.token).to eq(token)
    end

    context 'when SLACK_API_TOKEN is not defined in ENV' do
      it 'raises error' do
        allow(ENV).to receive(:[]).at_least(:once)
        allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(nil)

        expect { app }.to raise_error("Missing ENV['SLACK_API_TOKEN'].")
      end
    end
  end

  describe '.instance' do
    it 'creates an instance of the App subclass' do
      klass = Class.new(SlackRubyBot::App)
      expect(klass.instance.class).to be klass
    end
  end

  describe 'executable' do
    it 'can be required as a dependency' do
      response = system("ruby -e \"Bundler = nil ; require 'slack-ruby-bot'\"")
      expect(response).to be true
    end
  end
end
