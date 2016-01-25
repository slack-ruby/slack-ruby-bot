module SlackRubyBot
  class Client < Slack::RealTime::Client
    include Loggable
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

    def say(options = {})
      options = options.dup
      # get GIF
      keywords = options.delete(:gif)
      # text
      text = options.delete(:text)
      gif = begin
        Giphy.random(keywords)
      rescue StandardError => e
        logger.warn "Giphy.random: #{e.message}"
        nil
      end if SlackRubyBot::Config.send_gifs? && send_gifs? && keywords
      text = [text, gif && gif.image_url.to_s].compact.join("\n")
      message({ text: text }.merge(options))
    end
  end
end
