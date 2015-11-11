require 'spec_helper'

describe SlackRubyBot::Server do
  context 'with a token' do
    let(:client) { Slack::RealTime::Client.new }
    let(:logger) { subject.send :logger }
    subject do
      SlackRubyBot::Server.new(token: 'token')
    end
    before do
      allow(subject).to receive(:sleep)
      allow(logger).to receive(:error)
    end
    it 'creates a client with a token' do
      expect(client).to receive(:start!) { fail 'expected' }
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token').and_return(client)
      expect { subject.send :start! }.to raise_error RuntimeError, 'expected'
    end
    it 'stops client' do
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token').and_return(client)
      expect(client).to receive(:started?).and_return(true)
      subject.send :stop!
    end
  end
  context 'retries on rtm.start errors' do
    let(:client) { Slack::RealTime::Client.new }
    let(:logger) { subject.send :logger }
    before do
      allow(subject).to receive(:auth!)
      allow(subject).to receive(:sleep)
      allow(SlackRubyBot::Server).to receive(:auth!)
      expect(Slack::RealTime::Client).to receive(:new).twice.and_return(client)
      expect(logger).to receive(:error).twice
    end
    it 'migration_in_progress', vcr: { cassette_name: 'migration_in_progress' } do
      expect do
        subject.run
      end.to raise_error Slack::Web::Api::Error, 'unknown'
    end
    [Faraday::Error::ConnectionFailed, Faraday::Error::TimeoutError, Faraday::Error::SSLError].each do |err|
      it "#{err}" do
        expect(client).to receive(:start!) { fail err, 'Faraday' }
        expect(client).to receive(:start!) { fail 'unknown' }
        expect do
          subject.run
        end.to raise_error 'unknown'
      end
    end
  end
end
