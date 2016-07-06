module SlackRubyBot
  module Loggable
    def self.included(base)
      base.send :include, LoggingMethods
      base.extend(LoggingMethods)
    end
  end

  module LoggingMethods
    def logger
      $logger ||= begin
                    $stdout.sync = true
                    Logger.new(STDOUT)
                  end
    end
  end
end
