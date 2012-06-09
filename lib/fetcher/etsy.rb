require 'api_key'

module Fetcher
  class Etsy < Base
    include APIKey

    api_key_param_name :api_key
    base_uri "openapi.etsy.com/v2"
    format :json

    LISTING_FIELDS = [:title, :price, :currency_code, :url, :ending_tsz].freeze

    default_params(
      limit:      5,
      sort_on:    "created",
      sort_order: "down",
      fields:     LISTING_FIELDS.join(',')
    )

    add_fetcher_options after: :format_items

    def uri
      "/listings/active"
    end

    private
    def options
      wrap_query_options api_key_option.merge keywords: @cue.split(/\s/).join(',')
    end

    def format_items
      @data[:results].map{ |item| extract_desired_fields item }
    end

    def extract_desired_fields( item_data )
      LISTING_FIELDS.each_with_object({}) do |field, data|
        data[field] = item_data[field]
      end
    end
  end
end
