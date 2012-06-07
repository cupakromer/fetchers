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

    def after_fetch
      fail "Must be implemented by child class"
    end

    def uri
      fail "Must define uri"
    end

    def self.fetcher(options = {}, &block)
      define_method('fetch') do
        result = http_request(uri) do |data|
          block.call(data)
        end

        after_fetch(result)
      end
    end

    private
    attr_reader :last_request_status

    def http_request(url, options = {})
      response = self.class.get url, options

      if /^2\d\d$/ =~ response.code.to_s
        @last_request_status = true
        @message = "Request succeeded"
        block_given? ? yield(response.parsed_response) : response
      else
        @last_request_status = false
        @message = "HTTP request failed for #{url}: '#{response.message}'"
      end
    end
  end
end
