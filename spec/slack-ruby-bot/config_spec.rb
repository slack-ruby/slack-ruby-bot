require 'spec_helper'

describe SlackRubyBot::Config do
  describe '.send_gifs?' do
    after { ENV.delete 'SLACK_RUBY_BOT_SEND_GIFS' }

    context 'without giphy is false', unless: ENV.key?('WITH_GIPHY') do
      it 'by default' do
        expect(SlackRubyBot::Config.send_gifs?).to be false
      end
      it 'when set to true' do
        SlackRubyBot::Config.send_gifs = true
        expect(SlackRubyBot::Config.send_gifs?).to be false
      end
      it 'when set to true via SLACK_RUBY_BOT_SEND_GIFS' do
        ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'true'
        expect(SlackRubyBot::Config.send_gifs?).to be false
      end
    end
    context 'with giphy', if: ENV.key?('WITH_GIPHY') do
      it 'default is true' do
        expect(SlackRubyBot::Config.send_gifs?).to be true
      end
      context 'set to false' do
        it 'is false' do
          SlackRubyBot::Config.send_gifs = false
          expect(SlackRubyBot::Config.send_gifs?).to be false
        end
      end
      context 'set to false via SLACK_RUBY_BOT_SEND_GIFS' do
        it 'is false' do
          ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'false'
          expect(SlackRubyBot::Config.send_gifs?).to be false
        end
      end
      context 'set to true' do
        it 'is true' do
          SlackRubyBot::Config.send_gifs = true
          expect(SlackRubyBot::Config.send_gifs?).to be true
        end
      end
      context 'set to true via SLACK_RUBY_BOT_SEND_GIFS' do
        it 'is true' do
          ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'true'
          expect(SlackRubyBot::Config.send_gifs?).to be true
        end
      end
      context 'when using both methods' do
        it 'config setting takes precedence' do
          ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'true'
          SlackRubyBot::Config.send_gifs = false
          expect(SlackRubyBot::Config.send_gifs?).to be false
          ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'false'
          SlackRubyBot::Config.send_gifs = true
          expect(SlackRubyBot::Config.send_gifs?).to be true
        end
      end
    end
  end

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
