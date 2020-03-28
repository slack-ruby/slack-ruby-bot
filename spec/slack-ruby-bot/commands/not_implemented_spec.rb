# frozen_string_literal: true

describe SlackRubyBot::Commands::Base do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'not_implemented'
    end
  end
  it 'raises not implemented' do
    expect(message: "#{SlackRubyBot.config.user} not_implemented").to respond_with_error(NotImplementedError, 'rubybot not_implemented')
  end
end
