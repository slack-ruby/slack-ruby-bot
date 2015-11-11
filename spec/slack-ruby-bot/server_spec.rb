require 'spec_helper'

describe SlackRubyBot::Server do
  def app
    SlackRubyBot::Server.new
  end
  context 'retries on rtm.start errors' do
    let(:client) { Slack::RealTime::Client.new }
    let(:logger) { subject.send :logger }
    before do
      allow(subject).to receive(:sleep)
      expect(Slack::RealTime::Client).to receive(:new).twice.and_return(client)
      expect(logger).to receive(:error).twice
    end
    it 'migration_in_progress', vcr: { cassette_name: 'migration_in_progress' } do
      expect do
        subject.send :start!
      end.to raise_error Slack::Web::Api::Error, 'unknown'
    end
    [Faraday::Error::ConnectionFailed, Faraday::Error::TimeoutError, Faraday::Error::SSLError].each do |err|
      it "#{err}" do
        expect(client).to receive(:start!) { fail err, 'Faraday' }
        expect(client).to receive(:start!) { fail 'unknown' }
        expect do
          subject.send :start!
        end.to raise_error 'unknown'
      end
    end
  end
end
