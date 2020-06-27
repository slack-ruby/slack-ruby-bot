# frozen_string_literal: true

module SlackRubyBot
  class Client < Slack::RealTime::Client
    include Loggable
    attr_accessor :aliases
    attr_accessor :allow_bot_messages
    attr_accessor :allow_message_loops

    def initialize(attrs = {})
      super(attrs)
      @aliases = attrs[:aliases]
      @allow_message_loops = attrs[:allow_message_loops]
      @allow_bot_messages = attrs[:allow_bot_messages]
    end

    def allow_message_loops?
      @allow_message_loops.nil? ? SlackRubyBot::Config.allow_message_loops? : !!@allow_message_loops
    end

    def allow_bot_messages?
      @allow_bot_messages.nil? ? SlackRubyBot::Config.allow_bot_messages? : !!@allow_bot_messages
    end

    def message_to_self?(data)
      !!(self.self && self.self.id == data.user)
    end

    def bot_message?(data)
      data.subtype == 'bot_message'
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
