# frozen_string_literal: true

module SlackRubyBot
  module MVC
    module Model
      class Base
        include ActiveSupport::Callbacks

        class << self
          def inherited(klass) # :nodoc:
            super
          end
        end

        attr_reader :client, :data, :match

        # Hand off the latest updated objects to the +model+ and +view+ and
        # update our +client+, +data+, and +match+ accessors.
        def use_args(client, data, match)
          @client = client
          @data = data
          @match = match
        end
      end
    end
  end
end
