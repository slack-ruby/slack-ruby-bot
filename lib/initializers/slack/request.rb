module Slack
  module Request
    private

    alias_method :_request, :request

    def request(method, path, options)
      response = _request(method, path, options)
      fail response['error'] unless response['ok'] if response.is_a?(Hash)
      response
    end
  end
end
