module SlackRubyBot
  module Loggable
    def logger
      @logger ||= begin
        $stdout.sync = true
        Logger.new(STDOUT)
      end
    end
  end
end
