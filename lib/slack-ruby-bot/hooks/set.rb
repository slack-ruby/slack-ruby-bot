# frozen_string_literal: true

module SlackRubyBot
  module Hooks
    class Set
      attr_accessor :handlers, :client

      def initialize(client = nil)
        self.handlers = {}
        self.client = client

        @pending_flush = client.blank?
      end

      def add(hook_name, handler)
        handlers[hook_name] ||= ::Set.new
        handlers[hook_name] << handler

        register_callback(hook_name)
      end

      def client=(client)
        @client = client

        flush_handlers if @pending_flush
      end

      protected

      def register_callback(hook_name)
        return unless client # We'll delay this until client is set

        client.on hook_name do |data|
          handlers[hook_name].each do |handler|
            handler.call(client, data)
          end
        end
      end

      def flush_handlers
        handlers.each_key { |hook| register_callback(hook) }
      end
    end
  end
end
