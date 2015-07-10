require 'spec_helper'

describe RSpec do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      command 'raise'

      def self.call(_data, command, _arguments)
        fail ArgumentError, command
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end
  it 'respond_with_error' do
    expect(message: "#{SlackRubyBot.config.user} raise").to respond_with_error('raise')
  end
end
