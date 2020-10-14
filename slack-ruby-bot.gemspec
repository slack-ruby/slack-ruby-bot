# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'slack-ruby-bot/version'

Gem::Specification.new do |s|
  s.name = 'slack-ruby-bot'
  s.version = SlackRubyBot::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.email = 'dblock@dblock.org'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/slack-ruby/slack-ruby-bot'
  s.licenses = ['MIT']
  s.summary = 'The easiest way to write a Slack bot in Ruby.'
  s.required_ruby_version = '>= 2.3'
  s.add_dependency 'activesupport'
  s.add_dependency 'hashie'
  s.add_dependency 'slack-ruby-client', '>= 0.14.0'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '0.80.1'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
