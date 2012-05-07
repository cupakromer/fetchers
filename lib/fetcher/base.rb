require 'net/http'

module Fetcher
  class Base
    def initialize cue
      @last_request_status = false
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
      else
        @last_request_status = false
      end
    end
  end
end
