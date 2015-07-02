require 'spec_helper'

describe SlackRubyBot::App do
  subject do
    SlackRubyBot::App.new
  end
  context 'not configured' do
    before do
      @slack_api_token = ENV.delete('SLACK_API_TOKEN')
    end
    after do
      ENV['SLACK_API_TOKEN'] = @slack_api_token
    end
    it 'requires SLACK_API_TOKEN' do
      expect { subject }.to raise_error RuntimeError, "Missing ENV['SLACK_API_TOKEN']."
    end
  end
  context 'configured', vcr: { cassette_name: 'auth_test' } do
    context 'run' do
      before do
        subject.send(:auth!)
      end
      it 'succeeds auth' do
        expect(subject.config.url).to eq 'https://rubybot.slack.com/'
        expect(subject.config.team).to eq 'team'
        expect(subject.config.user).to eq 'user'
        expect(subject.config.team_id).to eq 'TDEADBEEF'
        expect(subject.config.user_id).to eq 'UBAADFOOD'
      end
    end
  end
end
