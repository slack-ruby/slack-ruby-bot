module SlackRubyBot
  class Client < Slack::RealTime::Client
    include Loggable
    attr_accessor :aliases
    attr_accessor :send_gifs

    def initialize(attrs = {})
      super(attrs)
      @aliases = attrs[:aliases]
      @send_gifs = attrs[:send_gifs]
    end

    def names
      [
        SlackRubyBot::Config.user,
        self.self ? self.self.name : nil,
        aliases,
        SlackRubyBot::Config.aliases,
        self.self && self.self.id ? "<@#{self.self.id.downcase}>" : nil,
        SlackRubyBot::Config.user_id ? "<@#{SlackRubyBot::Config.user_id.downcase}>" : nil,
        self.self && self.self.id ? "<@#{self.self.id.downcase}>:" : nil,
        SlackRubyBot::Config.user_id ? "<@#{SlackRubyBot::Config.user_id.downcase}>:" : nil,
        self.self && self.self.name ? "#{self.self.name.downcase}:" : nil,
        SlackRubyBot::Config.user ? "#{SlackRubyBot::Config.user}:" : nil
      ].compact.flatten
    end

    def name?(name)
      name && names.include?(name.downcase)
    end

    def send_gifs?
      return false unless defined?(Giphy)
      send_gifs.nil? ? SlackRubyBot::Config.send_gifs? : send_gifs
    end

    def name
      SlackRubyBot.config.user || (self.self && self.self.name)
    end

    def url
      SlackRubyBot.config.url || super
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
      end if keywords && send_gifs?
      text = [text, gif && gif.image_url.to_s].compact.join("\n")
      message({ text: text }.merge(options))
    end
  end
end
