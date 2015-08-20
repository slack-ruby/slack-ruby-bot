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

    def names
      [user, aliases].compact.flatten
    end

    def name?(name)
      name && names.include?(name.downcase)
    end
  end
end
