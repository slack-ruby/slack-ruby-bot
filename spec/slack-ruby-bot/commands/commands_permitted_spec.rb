# frozen_string_literal: true

describe SlackRubyBot::Commands, 'permitted?' do
  let! :command do
    Class.new(SlackRubyBot::Commands::Base) do
      class << self
        attr_accessor :_flag1
        attr_accessor :_flag2
        def permitted?(_client, _data, match)
          match[:command] == 'saylo'
        end
      end
      @_flag1 = false
      @_flag2 = false
      command 'saylo' do |_client, _data, _match|
        self._flag1 = true
      end
      command 'sayallowed' do |_client, _data, _match|
        self._flag2 = true
      end
    end
  end
  def app
    SlackRubyBot::App.new
  end

  it 'allows command when returning true' do
    expect(message: "#{SlackRubyBot::Config.user} saylo").to not_respond
    expect(command._flag1).to be true
  end

  it 'denies command when returning false' do
    expect(message: "#{SlackRubyBot::Config.user} sayallowed").to not_respond
    expect(command._flag2).to be false
  end
end
