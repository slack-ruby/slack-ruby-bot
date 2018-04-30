# frozen_string_literal: true

module SlackRubyBot
  module SpecHelpers
    private

    def parse(actual)
      actual = { message: actual } unless actual.is_a?(Hash)
      attachments = actual[:attachments]
      attachments = [attachments] unless attachments.nil? || attachments.is_a?(Array)
      [actual[:channel] || 'channel', actual[:user] || 'user', actual[:message], attachments]
    end
  end
end
