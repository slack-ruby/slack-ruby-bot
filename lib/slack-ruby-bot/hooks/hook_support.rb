# frozen_string_literal: true

module SlackRubyBot
  module Hooks
    module HookSupport
      def self.included(base)
        base.cattr_accessor :hook_blocks

        base.extend(ClassMethods)
      end

      module ClassMethods
        def on(event_name, &block)
          self.hook_blocks ||= {}

          self.hook_blocks[event_name] ||= []
          self.hook_blocks[event_name] << block
        end
      end

      def on(event_name, handler)
        _hooks.add(event_name, handler)
      end

      def flush_hook_blocks
        return nil unless self.class.hook_blocks

        add_hook_handlers(self.class.hook_blocks)
      end

      # TODO: This should be deprecated in favor of `on`
      def add_hook_handlers(handler_hash)
        handler_hash.each do |hook, handlers|
          Array(handlers).each { |handler| on(hook, handler) }
        end
      end

      # Temp use this method in order to deprecate `hooks` and revisit
      def _hooks
        @hooks ||= SlackRubyBot::Hooks::Set.new
      end
      private :_hooks
    end
  end
end
