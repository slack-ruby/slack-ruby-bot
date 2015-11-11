module SlackRubyBot
  class Client < Slack::RealTime::Client
    attr_accessor :auth

    def names
      [
        SlackRubyBot::Config.user,
        auth ? auth['user'] : nil,
        SlackRubyBot::Config.aliases,
        auth ? "<@#{auth['user_id'].downcase}>" : nil,
        SlackRubyBot::Config.user_id ? "<@#{SlackRubyBot::Config.user_id.downcase}>" : nil,
        auth ? "<@#{auth['user_id'].downcase}>:" : nil,
        SlackRubyBot::Config.user_id ? "<@#{SlackRubyBot::Config.user_id.downcase}>:" : nil,
        auth ? "#{auth['user']}:" : nil,
        SlackRubyBot::Config.user ? "#{SlackRubyBot::Config.user}:" : nil
      ].compact.flatten
    end

    def name?(name)
      name && names.include?(name.downcase)
    end

    def name
      SlackRubyBot.config.user || (auth && auth['user'])
    end

    def url
      SlackRubyBot.config.url || (auth && auth['url'])
    end
  end
end
