module SlackRubyBot
  module Config
    extend self

    ATTRS = [:token, :url, :aliases, :user, :user_id, :team, :team_id, :allow_message_loops, :send_gifs].freeze
    attr_accessor(*ATTRS)

    def allow_message_loops?
      allow_message_loops
    end

    def send_gifs?
      return false unless defined?(Giphy)
      v = boolean_from_env('SLACK_RUBY_BOT_SEND_GIFS')
      send_gifs.nil? ? (v.nil? || v) : send_gifs
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
