require 'httparty'

module Fetcher
  class SymbolizedParser < HTTParty::Parser
    def json
      MultiJson.decode body, symbolize_keys: true
    end
  end

  class Base
    include HTTParty

    parser SymbolizedParser

    attr_reader :message, :data

    def initialize(cue)
      @cue = cue
      @last_request_status = false
      @message = ""
    end

    def success?
      last_request_status
    end

    def uri
      @cue
    end

    def options
      {}
    end

    def process_response( reponse_data )
      response_data
    end

    def fetch
      send(fetcher_options[:before]) if fetcher_options[:before]

      @data = http_request(uri, options) { |response_data|
        fetcher_filters.inject(response_data) { |data, filter|
          filter.call data
        }
      }

      @data = fetcher_options[:after] ? send(fetcher_options[:after]) : @data
    end

    private
    class << self
      attr_reader :fetcher_options
      attr_reader :fetcher_filters
    end

    def self.add_fetcher_options( methods )
      @fetcher_options ||= {}
      @fetcher_options.merge! methods
    end

    def self.add_fetcher_filters( *filters )
      @fetcher_filters ||= []
      @fetcher_filters += filters
    end

    def fetcher_options
      self.class.fetcher_options ||= {}
    end

    def fetcher_filters
      self.class.fetcher_filters ||= []
    end

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
