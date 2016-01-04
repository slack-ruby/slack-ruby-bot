module SlackRubyBot
  class Bot < SlackRubyBot::Commands::Base
    def self.run
      SlackRubyBot::App.instance.run
    end
  end
end
