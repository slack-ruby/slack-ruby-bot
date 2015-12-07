module SlackRubyBot
  module Config
    extend self

    attr_accessor :token
    attr_accessor :url
    attr_accessor :aliases
    attr_accessor :user
    attr_accessor :user_id
    attr_accessor :team
    attr_accessor :team_id
    attr_accessor :allow_message_loops
    attr_accessor :send_gifs

    def allow_message_loops?
      allow_message_loops
    end

    def send_gifs?
      v = boolean_from_env('SLACK_RUBY_BOT_SEND_GIFS')
      v.nil? ? (send_gifs.nil? || send_gifs) : v
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
        fail ArgumentError, "Invalid value for #{key}: #{value}."
      end
    end
  end
end
