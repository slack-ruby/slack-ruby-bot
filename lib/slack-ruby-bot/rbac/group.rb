require 'set'

module SlackRubyBot
  module RBAC
    class Group
      def initialize
        @users = Set.new
        @commands = Set.new
      end

      def add_user(user)
        @users << user.to_s
      end

      def add_command(command)
        @commands << command.to_s
      end

      def match_both?(user, command)
        user?(user.to_s) && command?(command.to_s)
      end

      private

      def user?(user)
        @users.include?(user)
      end

      def command?(command)
        @commands.include?(command)
      end
    end
  end
end
