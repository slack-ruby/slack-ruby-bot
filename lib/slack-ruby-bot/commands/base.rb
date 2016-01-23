module SlackRubyBot
  module Commands
    class Base
      class_attribute :routes

      def self.send_message(client, channel, text, options = {})
        logger.warn '[DEPRECATION] `send_message` is deprecated.  Please use `client.say` instead.'
        if text && text.length > 0
          client.say(options.merge(channel: channel, text: text))
        else
          client.say(options.merge(channel: channel, text: 'Nothing to see here.', gif: 'nothing'))
        end
      end

      def self.send_message_with_gif(client, channel, text, keywords, options = {})
        logger.warn '[DEPRECATION] `send_message_with_gif` is deprecated.  Please use `client.say` instead.'
        client.say(options.merge(channel: channel, text: text, gif: keywords))
      end

      def self.send_gif(client, channel, keywords, options = {})
        logger.warn '[DEPRECATION] `send_gif` is deprecated.  Please use `client.say` instead.'
        client.say(options.merge(channel: channel, text: '', gif: keywords))
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
          escaped = Regexp.escape(value)
          match Regexp.new("^(?<bot>[[:alnum:][:punct:]@<>]*)[\\s]+(?<command>#{escaped})$", Regexp::IGNORECASE), &block
          match Regexp.new("^(?<bot>[[:alnum:][:punct:]@<>]*)[\\s]+(?<command>#{escaped})[\\s]+(?<expression>.*)$", Regexp::IGNORECASE), &block
        end
      end

      def self.invoke(client, data)
        self.finalize_routes!
        expression, text = parse(client, data)
        called = false
        routes.each_pair do |route, method|
          match = route.match(expression)
          match ||= route.match(text) if text
          next unless match
          next if match.names.include?('bot') && !client.name?(match['bot'])
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

      def self.parse(client, data)
        text = data.text
        return text unless direct_message?(data) && message_from_another_user?(data)
        return text if bot_mentioned_in_message?(text, client.names)
        ["#{client.name} #{text}", text]
      end

      def self.direct_message?(data)
        data.channel && data.channel[0] == 'D'
      end

      def self.message_from_another_user?(data)
        data.user && data.user != SlackRubyBot.config.user_id
      end

      def self.bot_mentioned_in_message?(text, bot_names)
        bot_names = bot_names.join('|')
        !!text.downcase.match(/\A(#{bot_names})\s|\A(#{bot_names})\z/)
      end

      def self.finalize_routes!
        return if self.routes && self.routes.any?
        command default_command_name
      end
    end
  end
end
