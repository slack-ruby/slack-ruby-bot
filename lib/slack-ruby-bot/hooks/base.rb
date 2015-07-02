module SlackRubyBot
  module Hooks
    module Base
      def included(caller)
        caller.hooks ||= []
        caller.hooks << name.demodulize.underscore.to_sym
      end
    end
  end
end
