# frozen_string_literal: true

describe SlackRubyBot::Hooks::Hello do
  let(:logger) { double(:logger, info: nil) }
  let(:hello_hook) { described_class.new(logger) }

  describe '#call' do
    let(:team_name) { 'Example Team' }
    let(:team_id) { SecureRandom.uuid }
    let(:team_domain) { 'example' }
    let(:team) { double(:team, name: team_name, id: team_id, domain: team_domain) }
    let(:client) { instance_double(SlackRubyBot::Client, team: team) }

    def receive_hello
      hello_hook.call(client, double)
    end

    it 'logs the connection' do
      expect(logger).to receive(:info).with("Successfully connected team #{team_name} (#{team_id}) to https://#{team_domain}.slack.com.")
      receive_hello
    end

    context 'with no client' do
      let(:client) { nil }
      it 'does nothing' do
        expect(logger).not_to receive(:info)
        receive_hello
      end
    end

    context 'when client has no team' do
      let(:team) { nil }
      it 'does nothing' do
        expect(logger).not_to receive(:info)
        receive_hello
      end
    end

    context 'when hook is received multiple times' do
      before do
        receive_hello
      end

      it 'logs the reconnections' do
        expect(logger).to receive(:info).with(/^Successfully reconnected .+ after \S+s\.$/).twice
        receive_hello
        receive_hello
      end
    end
  end
end
