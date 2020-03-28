# frozen_string_literal: true

describe SlackRubyBot::Hooks::Set do
  let(:client) { Slack::RealTime::Client.new }

  context 'adding hooks' do
    subject { described_class.new(client) }

    it 'lets you add hook handlers' do
      handler = ->(_, _) {}

      expect do
        subject.add(:message, handler)
      end.to change(subject, :handlers)

      expect(subject.handlers).to have_key(:message)
      expect(subject.handlers[:message]).to eq Set.new.add(handler)
    end

    it 'lets you add multiple handlers for the same hook' do
      handler_1 = ->(_, _) {}
      handler_2 = ->(_, _) {}

      expect do
        subject.add(:message, handler_1)
        subject.add(:message, handler_2)
      end.to change(subject, :handlers)

      expect(subject.handlers).to have_key(:message)
      expect(subject.handlers[:message]).to eq Set.new([handler_1, handler_2])
    end
  end

  context 'Slack Client injection' do
    subject { described_class.new }

    it "doesn't barf when add callbacks prior to injecting client" do
      expect do
        subject.add(:hook, ->(_, _) {})
      end.to_not raise_error
    end

    it 'triggers hooks when client is configured later' do
      handler = ->(_, _) {}

      subject.add(:hook, handler)

      expect(subject).to receive(:flush_handlers).once.and_call_original
      expect(handler).to receive(:call).once

      subject.client = client

      client.send(:callback, { data: 1 }, :hook) # Abusing the callback method 100% :D
    end
  end
end
