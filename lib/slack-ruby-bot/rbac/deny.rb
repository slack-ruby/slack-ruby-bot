module SlackRubyBot
  module RBAC
    class DenyList < List
      def allowed_for?(user, command)
        return true unless command
        @groups.none? { |_group_name, group| group.match_both?(user, command) }
      end
    end
  end
end
