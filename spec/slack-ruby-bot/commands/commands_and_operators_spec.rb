require 'spec_helper'

describe SlackRubyBot::Commands do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      operator '='
      operator '-'

      command 'sayhi'
      command 'saybye'

      def self.call(data, command, arguments)
        send_message data.channel, "#{command}: #{arguments}"
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  before do
    app.config.user = 'rubybot'
  end
  it 'supports commands' do
    expect(message: 'rubybot sayhi arg1 arg2').to respond_with_slack_message('sayhi: ["arg1", "arg2"]')
    expect(message: 'rubybot saybye arg1 arg2').to respond_with_slack_message('saybye: ["arg1", "arg2"]')
  end
  it 'supports operators' do
    expect(message: '=2+2').to respond_with_slack_message('=: ["2+2"]')
  end
end
