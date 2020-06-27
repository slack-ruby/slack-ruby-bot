# frozen_string_literal: true

module SlackRubyBot
  module Config
    extend self

    ATTRS = %i[token url aliases user user_id team team_id allow_bot_messages allow_message_loops logger].freeze
    attr_accessor(*ATTRS)

    def allow_bot_messages?
      !!allow_bot_messages
    end

    def allow_message_loops?
      !!allow_message_loops
    end

    def reset!
      ATTRS.each { |attr| send("#{attr}=", nil) }
    end

    private

    def boolean_from_env(key)
      value = ENV[key]
      case value
      when nil
        nil
      when 0, 'false', 'no'
        false
      when 1, 'true', 'yes'
        true
      else
        raise ArgumentError, "Invalid value for #{key}: #{value}."
      end
    end
  end
end
