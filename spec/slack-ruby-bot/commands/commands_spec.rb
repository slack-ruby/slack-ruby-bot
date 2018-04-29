# frozen_string_literal: true

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'sayhi'
      command 'saybye'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'supports multiple commands' do
    expect(message: "#{SlackRubyBot.config.user} sayhi arg1 arg2").to respond_with_slack_message('sayhi: arg1 arg2')
    expect(message: "#{SlackRubyBot.config.user} saybye arg1 arg2").to respond_with_slack_message('saybye: arg1 arg2')
  end
  it 'checks for direct message' do
    expect(command.send(:direct_message?, Hashie::Mash.new(channel: 'D0K79RKJ7'))).to be true
    expect(command.send(:direct_message?, Hashie::Mash.new(channel: 'S0K79RKJ7'))).to be false
  end
  it 'checks that message from another user' do
    SlackRubyBot.config.user_id = 'UDEADBEEF'
    expect(command.send(:message_from_another_user?, Hashie::Mash.new(user: 'U0CPHNZ2N'))).to be true
    expect(command.send(:message_from_another_user?, Hashie::Mash.new(user: 'UDEADBEEF'))).to be false
  end
  it 'checks that bot mentioned in message' do
    bot_names = ['rubybot', '<@deadbeef>', '<@deadbeef>:', 'rubybot:']
    expect(command.send(:message_begins_with_bot_mention?, 'rubybot', bot_names)).to be true
    expect(command.send(:message_begins_with_bot_mention?, 'rubybot ', bot_names)).to be true
    expect(command.send(:message_begins_with_bot_mention?, 'rubybotbot', bot_names)).to be false
    expect(command.send(:message_begins_with_bot_mention?, 'rubybot:', bot_names)).to be true
    expect(command.send(:message_begins_with_bot_mention?, 'rubybot: ', bot_names)).to be true
    expect(command.send(:message_begins_with_bot_mention?, 'rubybot:bot', bot_names)).to be false
  end
end
