# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = File.join(File.dirname(__FILE__), 'fixtures/slack')
  config.hook_into :webmock
  # config.default_cassette_options = { record: :new_episodes }
  config.configure_rspec_metadata!
end
