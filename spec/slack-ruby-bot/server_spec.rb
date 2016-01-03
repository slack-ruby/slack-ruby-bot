require 'spec_helper'

describe SlackRubyBot::Server do
  let(:logger) { subject.send :logger }
  let(:client) { Slack::RealTime::Client.new }
  context 'with a token and disabled GIFs' do
    subject do
      SlackRubyBot::Server.new(token: 'token', send_gifs: false)
    end
    before do
      allow(subject).to receive(:sleep)
      allow(logger).to receive(:error)
    end
    it 'sets GIFs' do
      expect(subject.send(:client).send_gifs?).to be false
    end
  end
  context 'with a token and aliases' do
    subject do
      SlackRubyBot::Server.new(token: 'token', aliases: %w(foo bar))
    end
    before do
      allow(subject).to receive(:sleep)
      allow(logger).to receive(:error)
    end
    it 'sets aliases' do
      expect(subject.send(:client).aliases).to eq %w(foo bar)
      expect(subject.send(:client).names).to include 'foo'
    end
    it 'sets GIFs' do
      expect(subject.send(:client).send_gifs?).to be true
    end
    it 'creates a client with a token' do
      expect(client).to receive(:start!) { fail 'expected' }
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token', send_gifs: true, aliases: %w(foo bar)).and_return(client)
      expect { subject.start! }.to raise_error RuntimeError, 'expected'
    end
    it 'asynchronously creates a client with a token' do
      expect(client).to receive(:start_async) { fail 'expected' }
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token', send_gifs: true, aliases: %w(foo bar)).and_return(client)
      expect { subject.start_async }.to raise_error RuntimeError, 'expected'
    end
    it 'stops client' do
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token', send_gifs: true, aliases: %w(foo bar)).and_return(client)
      expect(subject.send(:client)).to_not be nil
      expect(client).to receive(:started?).and_return(true)
      subject.stop!
    end
  end
  context 'retries on rtm.start errors' do
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
