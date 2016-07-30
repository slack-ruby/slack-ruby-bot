require 'spec_helper'

describe SlackRubyBot::Client do
  describe '#send_gifs?' do
    it 'default is nil (disabled)' do
      expect(subject.send_gifs?).to be nil
    end

    it 'defaults to SlackRubyBot::Config.send_gifs?' do
      SlackRubyBot::Config.send_gifs = true
      expect(subject.send_gifs?).to be true
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
