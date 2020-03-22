describe SlackRubyBot::Hooks::Hello do
  let(:logger) { double(:logger, info: nil) }
  let(:message_hook) { described_class.new(logger) }

  describe '#initialize' do
    it 'sets reconnected' do
      expect(message_hook.instance_variable_get(:@reconnected)).to eq(false)
    end
  end

  # describe '#call' do
  #   it 'doesn\'t raise an error when message is a frozen string' do
  #     message_hook.call(
  #       SlackRubyBot::Client.new,
  #       Hashie::Mash.new(text: 'message'.freeze)
  #     )
  #   end
  # end
end
