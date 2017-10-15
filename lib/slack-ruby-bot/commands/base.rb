module SlackRubyBot
  module Commands
    class Base
      include Loggable
      class_attribute :routes

      class << self
        attr_accessor :command_classes

        def inherited(subclass)
          SlackRubyBot::Commands::Base.command_classes ||= []
          SlackRubyBot::Commands::Base.command_classes << subclass
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

        def command_name_from_class
          name ? name.split(':').last.downcase : object_id.to_s
        end

        def operator(*values, &block)
          values = values.map { |value| Regexp.escape(value) }.join('|')
          match Regexp.new("^(?<operator>#{values})(?<expression>.*)$", Regexp::IGNORECASE), &block
        end

        def command(*values, &block)
          values = values.map { |value| value.is_a?(Regexp) ? value.source : Regexp.escape(value) }.join('|')
          match Regexp.new("^#{bot_matcher}[\\s]+(?<command>#{values})([\\s]+(?<expression>.*)|)$", Regexp::IGNORECASE), &block
        end

        def invoke(client, data)
          finalize_routes!
          expression, text = parse(client, data)
          return false unless expression
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
            call_command(client, data, match, options[:block])
            return true
          end
          false
        end

        def match(match, &block)
          self.routes ||= ActiveSupport::OrderedHash.new
          self.routes[match] = { match_method: :match, block: block }
        end

        def scan(match, &block)
          self.routes ||= ActiveSupport::OrderedHash.new
          self.routes[match] = { match_method: :scan, block: block }
        end

        def bot_matcher
          '(?<bot>\S*)'
        end

        private

        def call_command(client, data, match, block)
          if block
            block.call(client, data, match) if permitted?(client, data, match)
          elsif respond_to?(:call)
            send(:call, client, data, match) if permitted?(client, data, match)
          else
            raise NotImplementedError, data.text
          end
        end

        def parse(client, data)
          text = data.text
          return text unless direct_message?(data) && message_from_another_user?(data)
          return text if message_begins_with_bot_mention?(text, client.names)
          ["#{client.name} #{text}", text]
        end

        def direct_message?(data)
          data.channel && data.channel[0] == 'D'
        end

        def message_from_another_user?(data)
          data.user && data.user != SlackRubyBot.config.user_id
        end

        def message_begins_with_bot_mention?(text, bot_names)
          bot_names = bot_names.join('|')
          !!text.downcase.match(/\A(#{bot_names})\s|\A(#{bot_names})\z/)
        end

        def finalize_routes!
          return if routes && routes.any?
          command command_name_from_class
        end

        # Intended to be overridden by subclasses to hook in an
        # authorization mechanism.
        def permitted?(_client, _data, _match)
          true
        end
      end
    end
  end
end
