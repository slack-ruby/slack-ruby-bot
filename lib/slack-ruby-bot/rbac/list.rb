module SlackRubyBot
  module RBAC
    class List
      def initialize
        @groups = Hash.new { |h, k| h[k] = Group.new }
      end

      def allowed_for?(_user, _command)
        raise NotImplementedError, 'Subclass must implement this method.'
      end

      def add_user_to_group(user, group)
        @groups[group].add_user(user)
      end

      def add_command_to_group(command, group)
        @groups[group].add_command(command)
      end
    end
  end
end
