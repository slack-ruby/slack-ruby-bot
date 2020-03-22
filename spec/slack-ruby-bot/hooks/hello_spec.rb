describe SlackRubyBot::Hooks::Hello do
  let(:logger) { double(:logger, info: nil) }
  let(:hello_hook) { described_class.new(logger) }

  describe '#initialize' do
    it 'sets reconnected' do
      expect(hello_hook.instance_variable_get(:@reconnected)).to eq(false)
    end
  end

  describe '#call' do
    let(:team_name) { 'Example Team' }
    let(:team_id) { SecureRandom.uuid }
    let(:team_domain) { 'example' }
    let(:team) { double(:team, name: team_name, id: team_id, domain: team_domain) }
    let(:client) { instance_double(SlackRubyBot::Client, team: team ) }
    it 'logs the connection' do
      expect(logger).to receive(:info).with("Successfully connected team #{team_name} (#{team_id}) to https://#{team_domain}.slack.com.")
      hello_hook.call(client, double)
    end
  end
end
