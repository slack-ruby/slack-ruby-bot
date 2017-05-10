module SlackRubyBot
  module Commands
    class Base
      include Loggable
      class_attribute :routes

      class << self
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
            execute_command_hooks(client, data, match) do
              if call
                call.call(client, data, match)
              elsif respond_to?(:call)
                send(:call, client, data, match)
              else
                raise NotImplementedError, data.text
              end
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

        def remove_command_hooks(type=nil, name=nil)
          setup_for_command_hooks
          case type
          when :before
            if name
              @before_command_hooks.delete(name)
            else
              @before_command_hooks.clear
            end
          when :after
            if name
              @after_command_hooks.delete(name)
            else
              @after_command_hooks.clear
            end
          else
            @before_command_hooks.clear
            @after_command_hooks.clear
          end
        end

        def before(verb=nil, &block)
          verb = verb ? verb.downcase : :global
          setup_for_command_hooks
          @before_command_hooks[verb] << block
        end

        def after(verb=nil, &block)
          verb = verb ? verb.downcase : :global
          setup_for_command_hooks
          @after_command_hooks[verb] << block
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

        def setup_for_command_hooks
          @before_command_hooks ||= Hash.new { |h,k| h[k] = [] }
          @after_command_hooks ||= Hash.new { |h,k| h[k] = [] }
        end

        def execute_command_hooks(client, data, match)
          if match.respond_to?(:named_captures)
            verb = match.named_captures['command']
            verb = verb.downcase if verb
            setup_for_command_hooks
            @before_command_hooks[:global].each { |blk| blk.call(client, data, match) }
            @before_command_hooks.select { |k,v| verb == k }.values.flatten.each { |blk| blk.call(client, data, match) }
            yield
            @after_command_hooks.select { |k,v| verb == k }.values.flatten.each { |blk| blk.call(client, data, match) }
            @after_command_hooks[:global].each { |blk| blk.call(client, data, match) }
          else
            # Not subject to a command hook, so pass through
            yield
          end
        end
      end
    end
  end
end
