module SlackRubyBot
  module Commands
    class Base
      class_attribute :routes

      def self.send_message(client, channel, text, options = {})
        if text && text.length > 0
          send_client_message(client, { channel: channel, text: text }.merge(options))
        else
          send_message_with_gif client, channel, 'Nothing to see here.', 'nothing', options
        end
      end

      def self.send_message_with_gif(client, channel, text, keywords, options = {})
        gif = begin
          Giphy.random(keywords)
        rescue StandardError => e
          logger.warn "Giphy.random: #{e.message}"
          nil
        end
        text = text + "\n" + gif.image_url.to_s if gif
        send_message client, channel, text, options
      end

      def self.send_gif(client, channel, keywords, options = {})
        gif = begin
          Giphy.random(keywords)
        rescue StandardError => e
          logger.warn "Giphy.random: #{e.message}"
          nil
        end
        text = gif.image_url.to_s if gif
        send_message client, channel, text, options
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

      def self.invoke(client, data)
        self.finalize_routes!
        expression = data.text
        called = false
        routes.each_pair do |route, method|
          match = route.match(expression)
          next unless match
          next if match.names.include?('bot') && match['bot'].downcase != SlackRubyBot.config.user
          called = true
          if method
            method.call(client, data, match)
          elsif self.respond_to?(:call)
            send(:call, client, data, match)
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

      def self.send_client_message(client, data)
        client.message(data)
      end

      def self.finalize_routes!
        return if self.routes && self.routes.any?
        command default_command_name
      end
    end
  end
end
