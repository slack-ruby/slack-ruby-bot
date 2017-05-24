module SlackRubyBot
  module RBAC
    class AllowList < List
      def allowed_for?(user, command)
        return false unless command
        @groups.any? { |_group_name, group| group.match_both?(user, command) }
      end
    end
  end
end
