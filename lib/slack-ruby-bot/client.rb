module SlackRubyBot
  class Client < Slack::RealTime::Client
    attr_accessor :auth
    attr_accessor :aliases
    attr_accessor :send_gifs

    def initialize(attrs = {})
      super(attrs)
      @aliases = attrs[:aliases]
      @send_gifs = attrs.key?(:send_gifs) ? !!attrs[:send_gifs] : true
    end

    def names
      [
        SlackRubyBot::Config.user,
        auth ? auth['user'] : nil,
        aliases,
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

    def send_gifs?
      send_gifs
    end

    def name
      SlackRubyBot.config.user || (auth && auth['user'])
    end

    def url
      SlackRubyBot.config.url || (auth && auth['url'])
    end
  end
end
