begin
  require 'GiphyClient'

  module Giphy
    module Config
      extend self

      attr_writer :api_key
      attr_writer :rating

      def api_key
        @api_key ||= ENV['GIPHY_API_KEY']
      end

      def rating
        @rating ||= 'G'
      end
    end

    class << self
      def configure
        block_given? ? yield(Config) : Config
      end

      def config
        Config
      end

      def client
        @client ||= GiphyClient::DefaultApi.new
      end

      def random(keywords)
        client.gifs_random_get(config.api_key, tag: keywords, rating: config.rating).data
      end
    end
  end
rescue LoadError
end
