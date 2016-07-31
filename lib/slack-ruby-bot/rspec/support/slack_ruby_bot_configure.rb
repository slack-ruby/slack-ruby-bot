RSpec.configure do |config|
  config.before :each do
    allow(Giphy).to receive(:random) if ENV.key?('WITH_GIPHY')
    SlackRubyBot.configure do |c|
      c.token = 'testtoken'
      c.user = 'rubybot'
      c.user_id = 'DEADBEEF'
    end
  end

  config.after :each do
    ENV.delete 'SLACK_RUBY_BOT_SEND_GIFS'
    SlackRubyBot::Config.reset!
  end
end
