# frozen_string_literal: true

describe SlackRubyBot::Client do
  describe '#allow_message_loops?' do
    context 'with global allow_message_loops set to true' do
      before do
        SlackRubyBot::Config.allow_message_loops = true
      end
      it do
        expect(subject.allow_message_loops?).to be true
      end
      context 'overridden locally' do
        subject do
          SlackRubyBot::Client.new(allow_message_loops: false)
        end
        it do
          expect(subject.allow_message_loops?).to be false
        end
      end
    end
    context 'with global allow_message_loops set to false' do
      before do
        SlackRubyBot::Config.allow_message_loops = false
      end
      it do
        expect(subject.allow_message_loops?).to be false
      end
      context 'overridden locally' do
        subject do
          SlackRubyBot::Client.new(allow_message_loops: true)
        end
        it do
          expect(subject.allow_message_loops?).to be true
        end
      end
    end
    context 'overridden locally' do
      subject do
        SlackRubyBot::Client.new(allow_message_loops: true)
      end
      it do
        expect(subject.allow_message_loops?).to be true
      end
    end
  end
  describe '#allow_bot_messages?' do
    context 'with global allow_bot_messages set to true' do
      before do
        SlackRubyBot::Config.allow_bot_messages = true
      end
      it do
        expect(subject.allow_bot_messages?).to be true
      end
      context 'overridden locally' do
        subject do
          SlackRubyBot::Client.new(allow_bot_messages: false)
        end
        it do
          expect(subject.allow_bot_messages?).to be false
        end
      end
    end
    context 'with global allow_bot_messages set to false' do
      before do
        SlackRubyBot::Config.allow_bot_messages = false
      end
      it do
        expect(subject.allow_bot_messages?).to be false
      end
      context 'overridden locally' do
        subject do
          SlackRubyBot::Client.new(allow_bot_messages: true)
        end
        it do
          expect(subject.allow_bot_messages?).to be true
        end
      end
    end
    context 'overridden locally' do
      subject do
        SlackRubyBot::Client.new(allow_bot_messages: true)
      end
      it do
        expect(subject.allow_bot_messages?).to be true
      end
    end
  end
  describe '#message_to_self?' do
    before do
      allow(subject).to receive(:self).and_return(Hashie::Mash.new({ 'id' => 'U0K8CKKT1' }))
    end
    context 'with message to self' do
      it do
        expect(subject.message_to_self?(Hashie::Mash.new(user: 'U0K8CKKT1'))).to be true
      end
    end
    context 'with message to another user' do
      it do
        expect(subject.message_to_self?(Hashie::Mash.new(user: 'U0K8CKKT2'))).to be false
      end
    end
  end
  describe '#bot_message?' do
    it 'bot message' do
      expect(subject.bot_message?(Hashie::Mash.new(subtype: 'bot_message'))).to be true
    end
    it 'not bot message' do
      expect(subject.bot_message?(Hashie::Mash.new(subtype: 'other'))).to be false
    end
    it 'no subtype' do
      expect(subject.bot_message?(Hashie::Mash.new)).to be false
    end
  end
end
