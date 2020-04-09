# frozen_string_literal: true

RSpec.configure do |config|
  config.before :each do
    ENV['SLACK_API_TOKEN'] ||= 'test'
  end
end
