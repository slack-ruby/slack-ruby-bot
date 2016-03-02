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

      # Instance stuff
      def hooks
        @hooks ||= SlackRubyBot::Hooks::Set.new
      end

      def flush_hook_blocks
        return nil unless self.class.hook_blocks

        add_hook_handlers(self.class.hook_blocks)
      end

      def add_hook_handlers(handler_hash)
        handler_hash.each do |hook, handlers|
          Array(handlers).each { |handler| hooks.add(hook, handler) }
        end
      end
    end
  end
end
