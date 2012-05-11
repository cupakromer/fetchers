require 'json'

module Fetcher
  class Etsy < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    BASE_URL = "http://openapi.etsy.com/v2"
    ACTIVE_LISTINGS_URI = "/listings/active"
    LISTING_FIELDS = "title,price,currency_code,url,ending_tsz"

    def fetch
      parameters = "limit=5&sort_on=created&sort_order=down&keywords=#{@cue.split(/\s/).join(',')}"
      fields = "fields=#{LISTING_FIELDS}"
      url = "#{BASE_URL}#{ACTIVE_LISTINGS_URI}?" +
        "api_key=#{Fetcher::Etsy.API_Key}&#{parameters}&#{fields}"

      data = http_request(url) { |json_data|
        JSON.parse json_data, allow_nan: true, symbolize_names: true
      }[:results]

      @data = extract_items data
    end

    private
    def extract_items data
      data.map{ |item| extract_desired_fields item }
    end

    def extract_desired_fields item_data
      LISTING_FIELDS.split(',').each_with_object({}) do |field, data|
        data[field.to_sym] = item_data[field.to_sym]
      end
    end
  end
end
