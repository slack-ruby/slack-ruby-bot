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
        get_gif_and_send({
          client: client,
          channel: channel,
          text: text,
          keywords: keywords
        }.merge(options))
      end

      def self.send_gif(client, channel, keywords, options = {})
        get_gif_and_send({
          client: client,
          channel: channel,
          keywords: keywords
        }.merge(options))
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
          match Regexp.new("^(?<bot>[\\w[:punct:]@<>]*)[\\s]+(?<command>#{value})$", Regexp::IGNORECASE), &block
          match Regexp.new("^(?<bot>[\\w[:punct:]@<>]*)[\\s]+(?<command>#{value})[\\s]+(?<expression>.*)$", Regexp::IGNORECASE), &block
        end
      end

      def self.invoke(client, data)
        self.finalize_routes!
        expression = parse(data)
        called = false
        routes.each_pair do |route, method|
          match = route.match(expression)
          next unless match
          next if match.names.include?('bot') && !SlackRubyBot.config.name?(match['bot'])
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

      def self.parse(data)
        text = data.text
        return text unless data.channel && data.channel[0] == 'D' && data.user && data.user != SlackRubyBot.config.user_id
        SlackRubyBot.config.names.each do |name|
          text.downcase.tap do |td|
            return text if td == name || td.starts_with?("#{name} ")
          end
        end
        "#{SlackRubyBot.config.user} #{text}"
      end

      def self.finalize_routes!
        return if self.routes && self.routes.any?
        command default_command_name
      end

      def self.get_gif_and_send(options = {})
        options = options.dup
        gif = begin
          keywords = options.delete(:keywords)
          Giphy.random(keywords)
        rescue StandardError => e
          logger.warn "Giphy.random: #{e.message}"
          nil
        end
        client = options.delete(:client)
        text = options.delete(:text)
        text = [text, gif && gif.image_url.to_s].compact.join("\n")
        send_client_message(client, { text: text }.merge(options))
      end

      def self.send_client_message(client, data)
        client.message(data)
      end
    end
  end
end
