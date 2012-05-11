require 'json'

module Fetcher
  class Etsy < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    BASE_URL = "http://openapi.etsy.com/v2"
    ACTIVE_LISTINGS_URI = "/listings/active"

    LISTING_FIELDS = %w[title price currency_code url ending_tsz].freeze

    PARAMETERS = {
      limit:      5,
      sort_on:    "created",
      sort_order: "down",
    }.freeze

    def fetch
      data = http_request(generate_url) { |json_data|
        JSON.parse json_data, allow_nan: true, symbolize_names: true
      }[:results]

      @data = extract_items data
    end

    private
    def generate_url
      "#{BASE_URL}#{ACTIVE_LISTINGS_URI}?api_key=#{self.class.API_Key}&" \
      "#{parameters_query}&#{keywords_query}&#{fields_query}"
    end

    def keywords_query
      "keywords=#{@cue.split(/\s/).join(',')}"
    end

    def fields_query
      "fields=#{LISTING_FIELDS.join ','}"
    end

    def parameters_query
      PARAMETERS.map{ |k,v| "#{k}=#{v}" }.join '&'
    end

    def extract_items data
      data.map{ |item| extract_desired_fields item }
    end

    def extract_desired_fields item_data
      LISTING_FIELDS.each_with_object({}) do |field, data|
        data[field.to_sym] = item_data[field.to_sym]
      end
    end
  end
end
