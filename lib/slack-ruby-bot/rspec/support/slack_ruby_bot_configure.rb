RSpec.configure do |config|
  config.before :each do
    SlackRubyBot.configure do |c|
      c.token = 'testtoken'
      c.user = 'rubybot'
    end
  end
end
