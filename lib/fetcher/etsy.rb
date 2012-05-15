require 'json'

module Fetcher
  class Etsy < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    base_uri "openapi.etsy.com/v2"
    format :json

    ACTIVE_LISTINGS_URI = "/listings/active"

    LISTING_FIELDS = %w[title price currency_code url ending_tsz].freeze

    default_params(limit:      5,
      sort_on:    "created",
      sort_order: "down",
                  )

    def fetch
      most_recent_items = http_request(ACTIVE_LISTINGS_URI, options)["results"]

      @data = format_items most_recent_items
    end

    private
    def options
      { query: generate_query }
    end

    def generate_query
      {
        api_key:  self.class.API_Key,
        keywords: @cue.split(/\s/).join(','),
        fields:   LISTING_FIELDS.join(','),
      }
    end

    def format_items(data)
      data.map{ |item| extract_desired_fields item }
    end

    def extract_desired_fields(item_data)
      LISTING_FIELDS.each_with_object({}) do |field, data|
        data[field.to_sym] = item_data[field]
      end
    end
  end
end
