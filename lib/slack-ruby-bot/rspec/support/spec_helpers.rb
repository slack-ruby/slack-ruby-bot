module SlackRubyBot
  module SpecHelpers
    private

    def parse(actual)
      actual = { message: actual } unless actual.is_a?(Hash)
      [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message]]
    end
  end
end
