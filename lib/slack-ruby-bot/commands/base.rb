module SlackRubyBot
  module Commands
    class Base
      class_attribute :routes

      def self.send_message(channel, text, options = { as_user: true })
        if text && text.length > 0
          chat_postMessage({ channel: channel, text: text }.merge(options))
        else
          send_message_with_gif channel, 'Nothing to see here.', 'nothing', options
        end
      end

      def self.send_message_with_gif(channel, text, keywords, options = { as_user: true })
        gif = begin
          Giphy.random(keywords)
        rescue StandardError => e
          logger.warn "Giphy.random: #{e.message}"
          nil
        end
        text = text + "\n" + gif.image_url.to_s if gif
        send_message channel, text, options
      end

      def self.logger
        @logger ||= begin
          $stdout.sync = true
          Logger.new(STDOUT)
        end
      end

      def self.default_command_name
        name && name.split(':').last.downcase
      end

      def self.operator(*values, &block)
        values.each do |value|
          match Regexp.new("^(?<operator>\\#{value})(?<expression>.*)$", Regexp::IGNORECASE), &block
        end
      end

      def self.command(*values, &block)
        values.each do |value|
          match Regexp.new("^(?<bot>\\w*)[\\s]+(?<command>#{value})$", Regexp::IGNORECASE), &block
          match Regexp.new("^(?<bot>\\w*)[\\s]+(?<command>#{value})[\\s]+(?<expression>.*)$", Regexp::IGNORECASE), &block
        end
      end

      def self.invoke(data)
        self.finalize_routes!
        expression = data.text
        called = false
        routes.each_pair do |route, method|
          match = route.match(expression)
          next unless match
          next if match.names.include?('bot') && match['bot'].downcase != SlackRubyBot.config.user
          called = true
          if method
            method.call(data, match)
          elsif self.respond_to?(:call)
            send(:call, data, match)
          else
            fail NotImplementedError, data.text
          end
          break
        end
        called
      end

      def self.match(match, &block)
        self.routes ||= {}
        self.routes[match] = block
      end

      private

      def self.chat_postMessage(message)
        Slack.chat_postMessage(message)
      end

      def self.finalize_routes!
        return if self.routes && self.routes.any?
        command default_command_name
      end
    end
  end
end
