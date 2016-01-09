module SlackRubyBot
  class Bot < SlackRubyBot::Commands::Base
    delegate :client, :run, to: :instance

    def self.instance
      SlackRubyBot::App.instance
    end
  end
end
