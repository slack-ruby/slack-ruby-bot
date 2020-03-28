# frozen_string_literal: true

module SlackRubyBot
  module MVC
    module Controller
      class Base
        include ActiveSupport::Callbacks

        class << self
          attr_reader :abstract
          alias abstract? abstract

          def controllers
            get_or_set_ivar(:@controllers, [])
          end

          def command_class
            get_or_set_ivar(:@command_class, Class.new(SlackRubyBot::Commands::Base))
          end

          def aliases
            get_or_set_ivar(:@aliases, Hash.new { |h, k| h[k] = [] })
          end

          def get_or_set_ivar(name, value)
            unless (ivar = Base.instance_variable_get(name))
              ivar = value
              Base.instance_variable_set(name, ivar)
            end
            ivar
          end

          def reset!
            # Remove any earlier anonymous classes from prior calls so we don't leak them
            Commands::Base.command_classes.delete(Controller::Base.command_class) if Base.command_class

            Base.instance_variable_set(:@command_class, nil)
            Base.instance_variable_set(:@controllers, nil)
          end

          # Define a controller as abstract. See internal_methods for more
          # details.
          def abstract!
            @abstract = true
          end

          def inherited(klass) # :nodoc:
            # Define the abstract ivar on subclasses so that we don't get
            # uninitialized ivar warnings
            klass.instance_variable_set(:@abstract, false) unless klass.instance_variable_defined?(:@abstract)
            super
          end

          def register_controller(controller)
            # Only used to keep a reference around so the instance object doesn't get garbage collected
            controllers << controller
            klass = controller.class

            methods = (klass.public_instance_methods(true) -
                       # Except for public instance methods of Base and its ancestors
                       internal_methods(klass) +
                       # Be sure to include shadowed public instance methods of this class
                       klass.public_instance_methods(false)).uniq.map(&:to_s)

            methods.each do |name|
              next if name[0] == '_'

              commands = lookup_command_name(name)

              # Generates a command for each controller method *and* its aliases
              commands.each do |command_string|
                # sprinkle a little syntactic sugar on top of existing `command` infrastructure
                command_class.class_eval do
                  command command_string do |client, data, match|
                    controller.use_args(client, data, match)
                    controller.call_command
                  end
                end
              end
            end
          end

          # A list of all internal methods for a controller. This finds the first
          # abstract superclass of a controller, and gets a list of all public
          # instance methods on that abstract class. Public instance methods of
          # a controller would normally be considered action methods, so methods
          # declared on abstract classes are being removed.
          # (Controller::Base is defined as abstract)
          def internal_methods(controller)
            controller = controller.superclass until controller.abstract?
            controller.public_instance_methods(true)
          end

          # Maps a controller method name to an alternate command name. Used in cases where
          # a command can be called via multiple text strings.
          #
          # Call this method *after* defining the original method.
          #
          #  Class.new(SlackRubyBot::MVC::Controller::Base) do
          #    def quxo_foo_bar
          #      client.say(channel: data.channel, text: "quxo foo bar: #{match[:expression]}")
          #    end
          #    # setup alias name after original method definition
          #    alternate_name :quxo_foo_bar, :another_text_string
          #  end
          #
          # This is equivalent to:
          #
          # e.g.
          #  command 'quxo foo bar', 'another text string' do |*args|
          #    ..
          #  end
          def alternate_name(original_name, *alias_names)
            command_name = convert_method_name_to_command_string(original_name)
            command_aliases = alias_names.map do |name|
              convert_method_name_to_command_string(name)
            end

            aliases[command_name] += command_aliases

            alias_names.each { |alias_name| alias_method(alias_name, original_name) }
          end

          private

          def lookup_command_name(name)
            name = convert_method_name_to_command_string(name)
            [name] + aliases[name]
          end

          def convert_method_name_to_command_string(name)
            name.to_s.tr('_', ' ')
          end
        end

        abstract!
        reset!

        attr_reader :model, :view, :client, :data, :match

        def initialize(model, view)
          @model = model
          @view = view
          self.class.register_controller(self)
        end

        # Hand off the latest updated objects to the +model+ and +view+ and
        # update our +client+, +data+, and +match+ accessors.
        def use_args(client, data, match)
          @client = client
          @data = data
          @match = match
          model.use_args(client, data, match)
          view.use_args(client, data, match)
        end

        # Determine the command issued and call the corresponding instance method
        def call_command
          verb = match.captures[match.names.index('command')]
          verb = normalize_command_string(verb)
          public_send(verb)
        end

        private

        def normalize_command_string(string)
          string.downcase.tr(' ', '_')
        end
      end
    end
  end
end
