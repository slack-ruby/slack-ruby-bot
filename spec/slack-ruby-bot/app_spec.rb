require 'spec_helper'

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  it_behaves_like 'a slack ruby bot'
  context 'retries on rtm.start errors' do
    before do
      allow(subject).to receive(:sleep)
    end
    it 'migration_in_progress', vcr: { cassette_name: 'migration_in_progress' } do
      expect do
        client = Slack::RealTime::Client.new
        expect(Slack::RealTime::Client).to receive(:new).twice.and_return(client)
        subject.send :start!
      end.to raise_error Slack::Web::Api::Error, 'unknown'
    end
  end
end
