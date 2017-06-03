require 'cancancan'

class User
  ROLES = { 0 => :guest, 1 => :user, 2 => :moderator, 3 => :admin }.freeze

  attr_reader :role

  def initialize(role_id = 0)
    @role = ROLES.key?(role_id.to_i) ? ROLES[role_id.to_i] : ROLES[0]
  end

  def role?(role_name)
    role == role_name
  end
end

class Ability
  include CanCan::Ability
end

describe SlackRubyBot::MVC::Controller::Base, 'execution with guest role' do
  let(:controller) do
    Class.new(SlackRubyBot::MVC::Controller::Base) do
      include CanCan::ControllerAdditions
      authorize_resource # doesn't work; assumes this is an +ActionController+ subclass for its meta-magic to work
      attr_accessor :__flag
      def quxo
        authorize! :quxo, self
        @__flag = true
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end

      def current_user
        @user ||= User.new(0)
      end

      def current_ability
        @current_ability = ::Ability.new(current_user)
      end

      class << self
        def name
          # anonymous classes don't have a name, but Cancancan relies on one
          'SpecController'
        end
      end
    end
  end

  after(:each) { controller.reset! }

  it 'denies access to run the controller method when no Ability is set' do
    Ability.class_eval do
      def initialize(user) end
    end
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    instance = controller.new(model, view)
    instance.current_ability
    instance.__flag = false
    expect(message: "  #{SlackRubyBot.config.user}   quxo red").to raise_from_command(CanCan::AccessDenied, 'You are not authorized to access this page.')
    expect(instance.__flag).to be false
  end

  it 'allows access to run the controller method when an Ability is set' do
    Ability.class_eval do
      def initialize(_user)
        can :quxo, :all
      end
    end
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    instance = controller.new(model, view)
    instance.current_ability
    instance.__flag = false
    expect(message: "  #{SlackRubyBot.config.user}   quxo red").to invoke_command('quxo: red')
    expect(instance.__flag).to be_truthy
  end
end
