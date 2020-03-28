# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each do
    SlackRubyBot.configure do |c|
      c.token = 'testtoken'
      c.user = 'rubybot'
      c.user_id = 'DEADBEEF'
    end
  end

  config.after :each do
    SlackRubyBot::Config.reset!
  end
end
