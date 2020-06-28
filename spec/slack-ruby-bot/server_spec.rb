# frozen_string_literal: true

describe SlackRubyBot::Server do
  let(:logger) { subject.send :logger }
  let(:client) { Slack::RealTime::Client.new }

  describe 'forwards settings to client' do
    before do
      allow(subject).to receive(:sleep)
      allow(logger).to receive(:error)
    end

    it 'token' do
      server = SlackRubyBot::Server.new(token: 'token')
      expect(server.send(:client).token).to eq 'token'
    end

    it 'aliases' do
      server = SlackRubyBot::Server.new(aliases: %w[foo bar])
      expect(server.send(:client).aliases).to eq %w[foo bar]
      expect(server.send(:client).names).to include 'foo'
    end
  end

  describe 'starting/stopping' do
    subject do
      SlackRubyBot::Server.new(token: 'token')
    end
    it 'creates a client with a token' do
      expect(client).to receive(:start!) { raise 'expected' }
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token', aliases: nil).and_return(client)
      expect { subject.start! }.to raise_error RuntimeError, 'expected'
    end
    it 'asynchronously creates a client with a token' do
      expect(client).to receive(:start_async) { raise 'expected' }
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token', aliases: nil).and_return(client)
      expect { subject.start_async }.to raise_error RuntimeError, 'expected'
    end
    it 'stops client' do
      expect(Slack::RealTime::Client).to receive(:new).with(token: 'token', aliases: nil).and_return(client)
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
      allow(logger).to receive(:error)
    end
    it 'migration_in_progress', vcr: { cassette_name: 'migration_in_progress' } do
      expect do
        subject.run
      end.to raise_error Slack::Web::Api::Error, 'unknown'
    end
    [Faraday::ConnectionFailed, Faraday::TimeoutError, Faraday::SSLError].each do |err|
      it err.to_s do
        expect(client).to receive(:start!) { raise err, 'Faraday' }
        expect(client).to receive(:start!) { raise 'unknown' }
        expect do
          subject.run
        end.to raise_error 'unknown'
      end
    end
  end
  context 'exits without error' do
    subject do
      SlackRubyBot::Server.new(token: 'token')
    end
    before do
      allow(subject).to receive(:auth!)
      allow(subject).to receive(:start!)
    end
    SlackRubyBot::Server::TRAPPED_SIGNALS.each do |signal|
      it "if #{signal} signal received" do
        server_pid = fork { subject.run }
        sleep 0.1
        Process.kill(signal, server_pid)
        _, status = Process.waitpid2(server_pid)
        expect(status.success?).to be true
      end
    end
  end
end
