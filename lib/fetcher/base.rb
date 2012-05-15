require 'httparty'

module Fetcher
  class Base
    include HTTParty
    attr_reader :message, :data

    def initialize(cue)
      @cue = cue
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

    def http_request(url, options = {})
      response = self.class.get url, options

      if /^2\d\d$/ =~ response.code.to_s
        @last_request_status = true
        @message = "Request succeeded"
        yield response.parsed_response if block_given?
      else
        @last_request_status = false
        @message = "HTTP request failed for #{url}: '#{response.message}'"
      end
    end
  end
end
