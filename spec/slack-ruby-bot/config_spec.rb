require 'spec_helper'

describe SlackRubyBot::Config do
  context 'send_gifs?' do
    context 'default' do
      it 'is true' do
        expect(SlackRubyBot::Config.send_gifs?).to be true
      end
    end
    context 'set to false' do
      before do
        SlackRubyBot::Config.send_gifs = false
      end
      it 'is false' do
        expect(SlackRubyBot::Config.send_gifs?).to be false
      end
      after do
        SlackRubyBot::Config.send_gifs = nil
      end
    end
    context 'set to false via SLACK_RUBY_BOT_SEND_GIFS' do
      before do
        ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'false'
      end
      it 'is false' do
        expect(SlackRubyBot::Config.send_gifs?).to be false
      end
      after do
        ENV.delete 'SLACK_RUBY_BOT_SEND_GIFS'
      end
    end
    context 'set to true' do
      before do
        SlackRubyBot::Config.send_gifs = true
      end
      it 'is false' do
        expect(SlackRubyBot::Config.send_gifs?).to be true
      end
      after do
        SlackRubyBot::Config.send_gifs = nil
      end
    end
    context 'set to true via SLACK_RUBY_BOT_SEND_GIFS' do
      before do
        ENV['SLACK_RUBY_BOT_SEND_GIFS'] = 'true'
      end
      it 'is false' do
        expect(SlackRubyBot::Config.send_gifs?).to be true
      end
      after do
        ENV.delete 'SLACK_RUBY_BOT_SEND_GIFS'
      end
    end
  end
end
