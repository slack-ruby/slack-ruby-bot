# frozen_string_literal: true

describe SlackRubyBot::MVC::Controller::Base, 'initialization' do
  let(:model) { double('model') }
  let(:view) { double('view') }
  let(:controller) do
    Class.new(SlackRubyBot::MVC::Controller::Base) do
      def quxo() end
    end
  end

  after(:each) { controller.reset! }

  it 'sets :model accessor to passed in model' do
    expect(controller.new(model, view).model).to eq(model)
  end

  it 'sets :view accessor to passed in view' do
    expect(controller.new(model, view).view).to eq(view)
  end

  it 'saves the controller instance to the class' do
    instance = controller.new(model, view)
    expect(SlackRubyBot::MVC::Controller::Base.controllers).to include(instance)
    SlackRubyBot::MVC::Controller::Base.controllers.clear
  end

  it 'creates a command route on SlackRubyBot::Commands::Base' do
    controller.reset!
    route_count = 0
    controller.new(model, view)
    expect(controller.command_class.routes.size).to eq(route_count + 1)
  end

  it 'does NOT create a command route on SlackRubyBot::Commands::Base when method starts with a single "_"' do
    controller.reset!
    route_count = 0
    controller.class_eval do
      def _no_route_to_me() end
    end
    controller.new(model, view)
    expect(controller.command_class.routes.size).to eq(route_count + 1) # instead of +2
  end
end

describe SlackRubyBot::MVC::Controller::Base, 'setup' do
  let(:controller) do
    Class.new(SlackRubyBot::MVC::Controller::Base) do
      def quxo
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  after(:each) { controller.reset! }

  it 'passes client, data, and match args to the model' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    controller.new(model, view)
    expect(message: "  #{SlackRubyBot.config.user}   quxo red").to respond_with_slack_message('quxo: red')
    expect(model.client).to be_kind_of(SlackRubyBot::Client)
    expect(model.data).to be_kind_of(Hash)
    expect(model.match).to be_kind_of(SlackRubyBot::Commands::Support::Match)
  end

  it 'passes client, data, and match args to the view' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    controller.new(model, view)
    expect(message: "  #{SlackRubyBot.config.user}   quxo red").to respond_with_slack_message('quxo: red')
    expect(view.client).to be_kind_of(SlackRubyBot::Client)
    expect(view.data).to be_kind_of(Hash)
    expect(view.match).to be_kind_of(SlackRubyBot::Commands::Support::Match)
  end
end

describe SlackRubyBot::MVC::Controller::Base, 'execution' do
  let(:controller) do
    Class.new(SlackRubyBot::MVC::Controller::Base) do
      attr_accessor :__flag
      def quxo
        @__flag = true
        client.say(channel: data.channel, text: "#{match[:command]}: #{match[:expression]}")
      end
    end
  end

  after(:each) { controller.reset! }

  it 'runs the controller method' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    instance = controller.new(model, view)
    instance.__flag = false
    expect(message: "  #{SlackRubyBot.config.user}   quxo red").to respond_with_slack_message('quxo: red')
    expect(instance.__flag).to be_truthy
  end
end

describe SlackRubyBot::MVC::Controller::Base, 'command text conversion' do
  let(:controller) do
    Class.new(SlackRubyBot::MVC::Controller::Base) do
      def quxo_foo_bar
        client.say(channel: data.channel, text: "#{match[:command].downcase}: #{match[:expression]}")
      end
    end
  end

  after(:each) { controller.reset! }

  it 'converts a command with spaces into a controller method with underscores separating the tokens' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    controller.new(model, view)
    expect(message: "  #{SlackRubyBot.config.user}   quxo foo bar red").to respond_with_slack_message('quxo foo bar: red')
  end

  it 'converts a command with upper case letters into a lower case method call' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    controller.new(model, view)
    expect(message: "  #{SlackRubyBot.config.user}   Quxo Foo Bar red").to respond_with_slack_message('quxo foo bar: red')
  end
end

describe SlackRubyBot::MVC::Controller::Base, 'alternate command text conversion' do
  let(:controller) do
    Class.new(SlackRubyBot::MVC::Controller::Base) do
      def quxo_foo_bar
        client.say(channel: data.channel, text: "quxo foo bar: #{match[:expression]}")
      end
      alternate_name :quxo_foo_bar, :another_text_string, :third_text_string
    end
  end

  after(:each) { controller.reset! }

  it 'aliases another valid command string to the controller method' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    controller.new(model, view)
    expect(message: "  #{SlackRubyBot.config.user}   another text string red").to respond_with_slack_message('quxo foo bar: red')
  end

  it 'allows for aliasing multiple names in a single call' do
    model = SlackRubyBot::MVC::Model::Base.new
    view = SlackRubyBot::MVC::View::Base.new
    controller.new(model, view)
    expect(message: "  #{SlackRubyBot.config.user}   third text string red").to respond_with_slack_message('quxo foo bar: red')
  end
end
