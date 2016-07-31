require 'spec_helper'

describe SlackRubyBot::Client do
  describe '#send_gifs?' do
    context 'without giphy is false', unless: ENV.key?('WITH_GIPHY') do
      it 'by default' do
        expect(subject.send_gifs?).to be false
      end

      it 'when set to true' do
        subject.send_gifs = true
        expect(subject.send_gifs?).to be false
      end

      it 'when set to true via config' do
        SlackRubyBot::Config.send_gifs = true
        expect(SlackRubyBot::Config.send_gifs?).to be false
      end
    end

    context 'with giphy', if: ENV.key?('WITH_GIPHY') do
      it 'default is true' do
        expect(subject.send_gifs?).to be true
      end

      it 'defaults to SlackRubyBot::Config.send_gifs? if set' do
        SlackRubyBot::Config.send_gifs = false
        expect(subject.send_gifs?).to be false
      end

      it 'client setting takes precedence' do
        SlackRubyBot::Config.send_gifs = true
        subject.send_gifs = false
        expect(subject.send_gifs?).to be false
        SlackRubyBot::Config.send_gifs = false
        subject.send_gifs = true
        expect(subject.send_gifs?).to be true
      end
    end
  end
end
