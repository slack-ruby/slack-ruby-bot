# frozen_string_literal: true

RSpec.configure do |config|
  config.before :all do
    ENV['SLACK_API_TOKEN'] ||= 'test'
  end
end
