require 'spec_helper'

describe SlackRubyBot::Commands::Base do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'not_implemented'
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'raises not implemented' do
    expect(message: "#{SlackRubyBot.config.user} not_implemented").to respond_with_error(NotImplementedError, 'not_implemented')
  end
end
