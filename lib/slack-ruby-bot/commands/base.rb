# frozen_string_literal: true

require_relative 'support/match'
require_relative 'support/help'

module SlackRubyBot
  module Commands
    class Base
      include Loggable

      class << self
        attr_accessor :command_classes

        def inherited(subclass)
          SlackRubyBot::Commands::Base.command_classes ||= []
          SlackRubyBot::Commands::Base.command_classes << subclass
        end

        def help(&block)
          Support::Help.instance.capture_help(self, &block)
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
          match Regexp.new("^#{bot_matcher}[[:space:]]+(?<command>#{values})([[:space:]]+(?<expression>.*)|)$", Regexp::IGNORECASE | Regexp::MULTILINE), &block
        end

        def invoke(client, data)
          finalize_routes!
          expression, text = parse(client, data)
          return false unless expression || data.attachments

          routes.each_pair do |route, options|
            match_method = options[:match_method]
            case match_method
            when :match
              next unless expression

              match = route.match(expression)
              match ||= route.match(text) if text
              next unless match
              next if match.names.include?('bot') && !client.name?(match['bot'])

              match = Support::Match.new(match)
            when :scan
              next unless expression

              match = expression.scan(route)
              next unless match.any?
            when :attachment
              next unless data.attachments && !data.attachments.empty?

              match, attachment, field = match_attachments(data, route, options[:fields_to_scan])
              next unless match

              match = Support::Match.new(match, attachment, field)
            end
            call_command(client, data, match, options[:block])
            return true
          end
          false
        end

        def match(match, &block)
          routes[match] = { match_method: :match, block: block }
        end

        def scan(match, &block)
          routes[match] = { match_method: :scan, block: block }
        end

        def attachment(match, fields_to_scan = nil, &block)
          fields_to_scan = [fields_to_scan] unless fields_to_scan.nil? || fields_to_scan.is_a?(Array)
          routes[match] = {
            match_method: :attachment,
            block: block,
            fields_to_scan: fields_to_scan
          }
        end

        def bot_matcher
          '(?<bot>\S*)'
        end

        def routes
          @routes ||= ActiveSupport::OrderedHash.new
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
          return if routes&.any?

          command command_name_from_class
        end

        def match_attachments(data, route, fields_to_scan = nil)
          fields_to_scan ||= %i[pretext text title]
          data.attachments.each do |attachment|
            fields_to_scan.each do |field|
              next unless attachment[field]

              match = route.match(attachment[field])
              return match, attachment, field if match
            end
          end
          false
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
