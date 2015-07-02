require 'spec_helper'

describe SlackRubyBot::App do
  def app
    SlackRubyBot::App.new
  end
  it_behaves_like 'a slack ruby bot'
end
