module SlackRubyBot
  module Loggable
    mattr_accessor :logger

    def self.included(base)
      base.send :include, LoggingMethods
      base.extend(LoggingMethods)
    end

    def self.logger
      @logger ||= begin
                    $stdout.sync = true
                    Logger.new(STDOUT)
                  end
    end
  end

  module LoggingMethods
    def logger
      Loggable.logger
    end
  end
end
