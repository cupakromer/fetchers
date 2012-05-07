require 'net/http'

module Fetcher
  class Base
    attr_reader :message

    def initialize cue
      @last_request_status = false
      @message = ""
    end

    def success?
      last_request_status
    end

    def fetch
      fail "Must be implemented by child class"
    end

    private
    attr_reader :last_request_status

    def http_request url, options = {}
      # TODO: Gracefully handle no internet connection, timeouts, bad URLs.
      # Net::HTTP will just error in these cases and not return nice bad
      # response objects
      response = Net::HTTP.get_response URI url

      if "200" == response.code
        @last_request_status = true
        @message = "Request succeeded"
      else
        @last_request_status = false
        @message = "HTTP request failed for #{url}: '#{response.message}'"
      end
    end
  end
end
