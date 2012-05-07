require 'net/http'

module Fetcher
  class Base
    def initialize cue
    end

    def success?
      !!last_request_status
    end

    def fetch
      fail "Must be implemented by child class"
    end

    private

    def last_request_status
    end

    def http_request url, options = {}
      response = Net::HTTP.get_response URI url
    end
  end
end
