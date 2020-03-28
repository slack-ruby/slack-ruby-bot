# frozen_string_literal: true

describe SlackRubyBot do
  def app
    SlackRubyBot::App.new
  end
  context 'it responds to direct messages' do
    it 'with bot name' do
      expect(message: "#{SlackRubyBot.config.user} hi", channel: 'DEADBEEF').to respond_with_slack_message('Hi <@user>!')
    end
    it 'with bot name capitalized' do
      expect(message: "#{SlackRubyBot.config.user.upcase} hi", channel: 'DEADBEEF').to respond_with_slack_message('Hi <@user>!')
    end
    it 'with bot user id' do
      expect(message: "<@#{SlackRubyBot.config.user_id}> hi", channel: 'DEADBEEF').to respond_with_slack_message('Hi <@user>!')
    end
    it 'without bot name' do
      expect(message: 'hi', channel: 'DEADBEEF').to respond_with_slack_message('Hi <@user>!')
    end
  end
  context 'it responds to direct name calling' do
    it 'with bot name' do
      expect(message: SlackRubyBot.config.user.to_s, channel: 'DEADBEEF').to respond_with_slack_message(SlackRubyBot::ABOUT)
    end
    it 'with bot name capitalized' do
      expect(message: SlackRubyBot.config.user.upcase.to_s, channel: 'DEADBEEF').to respond_with_slack_message(SlackRubyBot::ABOUT)
    end
    it 'with bot user id' do
      expect(message: "<@#{SlackRubyBot.config.user_id}>", channel: 'DEADBEEF').to respond_with_slack_message(SlackRubyBot::ABOUT)
    end
    it 'with bot user id and a colon' do
      expect(message: "<@#{SlackRubyBot.config.user_id}>:", channel: 'DEADBEEF').to respond_with_slack_message(SlackRubyBot::ABOUT)
    end
    it 'with bot user id and a colon and a space' do
      expect(message: "<@#{SlackRubyBot.config.user_id}>: ", channel: 'DEADBEEF').to respond_with_slack_message(SlackRubyBot::ABOUT)
    end
  end
end
