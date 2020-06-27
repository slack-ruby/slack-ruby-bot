# frozen_string_literal: true

module SlackRubyBot
  class Client < Slack::RealTime::Client
    include Loggable
    attr_accessor :aliases
    attr_accessor :send_gifs

    def initialize(attrs = {})
      super(attrs)
      @aliases = attrs[:aliases]
    end

    def names
      [
        SlackRubyBot::Config.user,
        self.self ? self.self.name : nil,
        aliases ? aliases.map(&:downcase) : nil,
        SlackRubyBot::Config.aliases ? SlackRubyBot::Config.aliases.map(&:downcase) : nil,
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

    def name
      SlackRubyBot.config.user || self.self&.name
    end

    def url
      SlackRubyBot.config.url || super
    end

    def say(options = {})
      logger.warn '[DEPRECATION] `gif:` is deprecated and has no effect.' if options.key?(:gif)
      message({ text: '' }.merge(options))
    end
  end
end
