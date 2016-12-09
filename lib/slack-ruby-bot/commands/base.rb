module SlackRubyBot
  module Commands
    class Base
      include Loggable
      class_attribute :routes

      class << self
        attr_reader :command_classes

        def inherited(subclass)
          @command_classes ||= []
          @command_classes << subclass
        end

        def send_message(client, channel, text, options = {})
          logger.warn '[DEPRECATION] `send_message` is deprecated.  Please use `client.say` instead.'
          if text && !text.length.empty?
            client.say(options.merge(channel: channel, text: text))
          else
            client.say(options.merge(channel: channel, text: 'Nothing to see here.', gif: 'nothing'))
          end
        end

        def send_message_with_gif(client, channel, text, keywords, options = {})
          logger.warn '[DEPRECATION] `send_message_with_gif` is deprecated.  Please use `client.say` instead.'
          client.say(options.merge(channel: channel, text: text, gif: keywords))
        end

        def send_gif(client, channel, keywords, options = {})
          logger.warn '[DEPRECATION] `send_gif` is deprecated.  Please use `client.say` instead.'
          client.say(options.merge(channel: channel, text: '', gif: keywords))
        end

        def help(&block)
          CommandsHelper.instance.capture_help(self, &block)
        end

        def default_command_name
          name && name.split(':').last.downcase
        end

        def operator(*values, &block)
          values = values.map { |value| Regexp.escape(value) }.join('|')
          match Regexp.new("^(?<operator>#{values})(?<expression>.*)$", Regexp::IGNORECASE), &block
        end

        def command(*values, &block)
          values = values.map { |value| Regexp.escape(value) }.join('|')
          match Regexp.new("^(?<bot>[[:alnum:][:punct:]@<>]*)[\\s]+(?<command>#{values})([\\s]+(?<expression>.*)|)$", Regexp::IGNORECASE), &block
        end

        def invoke(client, data)
          finalize_routes!
          expression, text = parse(client, data)
          called = false
          routes.each_pair do |route, options|
            match_method = options[:match_method]
            case match_method
            when :match
              match = route.match(expression)
              match ||= route.match(text) if text
              next unless match
              next if match.names.include?('bot') && !client.name?(match['bot'])
            when :scan
              match = expression.scan(route)
              next unless match.any?
            end
            called = true
            call = options[:call]
            if call
              call.call(client, data, match)
            elsif respond_to?(:call)
              send(:call, client, data, match)
            else
              raise NotImplementedError, data.text
            end
            break
          end if expression
          called
        end

        def match(match, &block)
          self.routes ||= ActiveSupport::OrderedHash.new
          self.routes[match] = { match_method: :match, call: block }
        end

        def scan(match, &block)
          self.routes ||= ActiveSupport::OrderedHash.new
          self.routes[match] = { match_method: :scan, call: block }
        end

        private

        def parse(client, data)
          text = data.text
          return text unless direct_message?(data) && message_from_another_user?(data)
          return text if bot_mentioned_in_message?(text, client.names)
          ["#{client.name} #{text}", text]
        end

        def direct_message?(data)
          data.channel && data.channel[0] == 'D'
        end

        def message_from_another_user?(data)
          data.user && data.user != SlackRubyBot.config.user_id
        end

        def bot_mentioned_in_message?(text, bot_names)
          bot_names = bot_names.join('|')
          !!text.downcase.match(/\A(#{bot_names})\s|\A(#{bot_names})\z/)
        end

        def finalize_routes!
          return if routes && routes.any?
          command default_command_name
        end
      end
    end
  end
end
