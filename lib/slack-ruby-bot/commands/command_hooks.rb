module SlackRubyBot
  module Commands
    # class methods to modify the Commands::Base class. All methods are related to
    # providing before/after hooks to commands.
    module CommandHooks
      def remove_command_hooks(type = nil, name = nil)
        setup_for_command_hooks
        case type
        when :before
          if name
            @before_command_hooks.delete(name)
          else
            @before_command_hooks.clear
          end
        when :after
          if name
            @after_command_hooks.delete(name)
          else
            @after_command_hooks.clear
          end
        else
          @before_command_hooks.clear
          @after_command_hooks.clear
        end
      end

      def before(verb = nil, &block)
        verb = verb ? verb.downcase : :global
        setup_for_command_hooks
        @before_command_hooks[verb] << block
      end

      def after(verb = nil, &block)
        verb = verb ? verb.downcase : :global
        setup_for_command_hooks
        @after_command_hooks[verb] << block
      end

      private

      def setup_for_command_hooks
        @before_command_hooks ||= Hash.new { |h, k| h[k] = [] }
        @after_command_hooks ||= Hash.new { |h, k| h[k] = [] }
      end

      def execute_command_hooks(client, data, match)
        if match.respond_to?(:named_captures)
          verb = match.named_captures['command']
          verb = verb.downcase if verb
          setup_for_command_hooks
          @before_command_hooks[:global].each { |blk| blk.call(client, data, match) }
          @before_command_hooks.select { |k, _v| verb == k }.values.flatten.each { |blk| blk.call(client, data, match) }
          yield
          @after_command_hooks.select { |k, _v| verb == k }.values.flatten.each { |blk| blk.call(client, data, match) }
          @after_command_hooks[:global].each { |blk| blk.call(client, data, match) }
        else
          # Not subject to a command hook, so pass through
          yield
        end
      end
    end
  end
end
