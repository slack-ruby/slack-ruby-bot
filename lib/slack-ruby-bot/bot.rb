module SlackRubyBot
  class Bot < SlackRubyBot::Commands::Base
    delegate :client, to: :instance

    def self.run
      instance.run
    end

    def self.instance
      SlackRubyBot::App.instance
    end
  end
end
