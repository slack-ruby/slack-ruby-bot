# frozen_string_literal: true

describe SlackRubyBot::Config do
  describe '#reset!' do
    it 'sets all config attributes to nil' do
      SlackRubyBot::Config::ATTRS.each do |attr|
        SlackRubyBot::Config.send("#{attr}=", true)
        expect(SlackRubyBot::Config.send(attr)).to be true
      end
      SlackRubyBot::Config.reset!
      SlackRubyBot::Config::ATTRS.each do |attr|
        expect(SlackRubyBot::Config.send(attr)).to be nil
      end
    end
  end
end
