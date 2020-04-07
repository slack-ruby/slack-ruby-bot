# frozen_string_literal: true

shared_examples 'a slack ruby bot' do
  let(:token) { 'slack-api-token' }

  context 'not configured' do
    before do
      @slack_api_token = ENV.delete('SLACK_API_TOKEN')
      SlackRubyBot.configure { |config| config.token = nil }
    end
    after do
      ENV['SLACK_API_TOKEN'] = @slack_api_token
    end
    it 'requires SLACK_API_TOKEN' do
      expect { subject }.to raise_error RuntimeError, "Missing ENV['SLACK_API_TOKEN']."
    end
  end

  context 'when SLACK_API_TOKEN is defined in ENV but not config' do
    it 'sets config.token from ENV' do
      allow(ENV).to receive(:[]).and_call_original.at_least(:once)
      allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(token)
      SlackRubyBot.configure { |config| config.token = nil }

      expect(app.config.token).to eq(token)
    end
  end

  context 'when SLACK_API_TOKEN is not defined in ENV but is defined in config' do
    it 'sets config.token from config' do
      allow(ENV).to receive(:[]).at_least(:once)
      allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(nil)
      SlackRubyBot.configure { |config| config.token = token }

      expect(app.config.token).to eq(token)
    end
  end

  context 'when SLACK_API_TOKEN is defined in ENV and config' do
    it 'sets config.token from config' do
      token2 = 'another-api-token'
      allow(ENV).to receive(:[]).at_least(:once)
      allow(ENV).to receive(:[]).with('SLACK_API_TOKEN').and_return(token2)
      SlackRubyBot.configure { |config| config.token = token }

      expect(app.config.token).to eq(token)
    end
  end
end
