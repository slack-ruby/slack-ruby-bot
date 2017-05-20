module SlackRubyBot
  module MVC
    module Controller
      class Base
        include ActiveSupport::Callbacks

        class << self
          attr_reader :abstract
          alias_method :abstract?, :abstract
          @@command_class = nil

          def controllers
            @@controllers
          end

          def command_class
            @@command_class
          end

          def reset!
            # Remove any earlier anonymous classes from prior calls so we don't leak them
            Commands::Base.command_classes.delete(command_class) if command_class

            # Create anonymous class to hold our #commands; required by SlackRubyBot::Commands::Base
            @@command_class = Class.new(SlackRubyBot::Commands::Base)
            @@controllers = []
          end

          # Define a controller as abstract. See internal_methods for more
          # details.
          def abstract!
            @abstract = true
          end

          def inherited(klass) # :nodoc:
            # Define the abstract ivar on subclasses so that we don't get
            # uninitialized ivar warnings
            unless klass.instance_variable_defined?(:@abstract)
              klass.instance_variable_set(:@abstract, false)
            end
            super
          end

          def register_controller(controller)
            # Only used to keep a reference around so the instance object doesn't get garbage collected
            @@controllers << controller
            klass = controller.class

            methods = (klass.public_instance_methods(true) -
                       # Except for public instance methods of Base and its ancestors
                       internal_methods(klass) +
                       # Be sure to include shadowed public instance methods of this class
                       klass.public_instance_methods(false)).uniq.map(&:to_s)

            methods.each do |meth_name|
              next if meth_name[0..1] == '__'

              # sprinkle a little syntactic sugar on top of existing `command` infrastructure
              @@command_class.class_eval do
                command "#{meth_name}" do |client, data, match|
                  controller.use_args(client, data, match)
                  controller.call_command
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
        end

        abstract!
        reset!

        attr_reader :model, :view, :client, :data, :match

        def initialize(model, view)
          @model, @view = model, view
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
          verb = match.named_captures['command']
          verb = verb.downcase if verb
          public_send(verb)
        end
      end
    end
  end
end
