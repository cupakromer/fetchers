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
      # TODO: See Exceptional Ruby pg. 67, #fetch is a standard method on
      # collection classes
      fail "Must be implemented by child class"
    end

    private
    attr_reader :last_request_status

    def http_request(url, options = {})
      # TODO: This probably shouldn't be private or should be a new class
      response = self.class.get url, options

      if /^2\d\d$/ =~ response.code.to_s
        @last_request_status = true
        @message = "Request succeeded"
        block_given? ? yield(response.parsed_response) : response
      else
        # TODO: Look into the Caller-supplied fallback strategy
        # See Exceptional Ruby pg.67
        @last_request_status = false
        @message = "HTTP request failed for #{url}: '#{response.message}'"
      end
    end

    def wrap_query_options( options )
      { query: options }
    end

    # TODO: See Isolate Exception Handling Code pg. 71 Exceptional Ruby
  end
end
