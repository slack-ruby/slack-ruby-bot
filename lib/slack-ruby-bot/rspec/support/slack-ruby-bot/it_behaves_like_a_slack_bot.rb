# frozen_string_literal: true

shared_examples 'a slack ruby bot' do
  context 'not configured' do
    before do
      @slack_api_token = ENV.delete('SLACK_API_TOKEN')
      SlackRubyBot.configure { |config| config.token = nil }
    end
    after do
      ENV['SLACK_API_TOKEN'] = @slack_api_token
    end
    it 'requires SLACK_API_TOKEN' do
      expect { described_class.instance }.to raise_error RuntimeError, 'Missing Slack API Token.'
    end
  end
end
