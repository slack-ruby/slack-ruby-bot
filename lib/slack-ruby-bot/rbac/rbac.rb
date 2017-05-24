module SlackRubyBot
  module RBAC
    class << self
      def reset!
        if allow_mode?
          allow_list
        else
          deny_list
        end
      end

      def allow_mode?
        :rbac_allow == Config.rbac_allow
      end

      def deny_mode?
        !allow_mode?
      end

      # Works as a whitelist. All users are DENIED permission to run any command
      # by default. Adding groups, users, and commands sets up the allow list.
      # When any user attempts to run a command for which they are registered,
      # they are ALLOWED.
      def allow_list
        @rbac = AllowList.new
        @mode = :rbac_allow
      end

      # Works as a blacklist. All users are ALLOWED permission to run any command
      # by default. Adding groups, users, and commands sets up the deny list.
      # When any user attempts to run a command for which they are registered,
      # they are DENIED.
      #
      # This is the default Role-Based Access Control mode.
      def deny_list
        @rbac = DenyList.new
        @mode = :rbac_deny
      end

      def allowed_for?(user, command)
        @rbac.allowed_for?(user, command)
      end

      # Expects a hash where the keys are the group names and the value is an
      # array containing a list of users to be added to the named group.
      #
      #  example_hash = {
      #    :group1 => [:user1, :user2, :user3],
      #    :group2 => [:user3, :user4]
      #  }
      #
      def add_users_to_groups(hash)
        hash.keys.each do |group|
          hash[group].each do |user|
            add_user_to_group(user, group)
          end
        end
      end

      # Expects a hash where the keys are the group names and the value is an
      # array containing a list of commands to be added to the named group.
      #
      #  example_hash = {
      #   :group1 => [:command1, :command2],
      #   :group2 => [:command3, :command4]
      #  }
      #
      def add_commands_to_groups(hash)
        hash.keys.each do |group|
          hash[group].each do |command|
            add_command_to_group(command, group)
          end
        end
      end

      def add_user_to_group(user, group)
        @rbac.add_user_to_group(user, group)
      end

      def add_command_to_group(command, group)
        @rbac.add_command_to_group(command, group)
      end
    end
  end
end
