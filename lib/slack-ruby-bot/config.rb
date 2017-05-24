module SlackRubyBot
  module Config
    extend self

    ATTRS = [:token, :url, :aliases, :user, :user_id, :team, :team_id, :allow_message_loops, :send_gifs, :rbac_allow].freeze
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

    def rbac_allow=(val)
      @rbac_allow = if :rbac_allow == val || true == val
                      :rbac_allow
                    elsif val.nil?
                      nil
                    else
                      :rbac_deny
                    end

      RBAC.reset!
      @rbac_allow
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
