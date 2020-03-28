# frozen_string_literal: true

module SlackRubyBot
  module Commands
    module Support
      class Attrs
        attr_accessor :command_name, :command_desc, :command_long_desc
        attr_reader :klass, :commands

        def initialize(klass)
          @klass = klass
          @commands = []
        end

        def title(title)
          self.command_name = title
        end

        def desc(desc)
          self.command_desc = desc
        end

        def long_desc(long_desc)
          self.command_long_desc = long_desc
        end

        def command(title, &block)
          @commands << self.class.new(klass).tap do |k|
            k.title(title)
            k.instance_eval(&block)
          end
        end
      end
    end
  end
end
