require 'geocoder'
require 'geocoder/results/google'

class Geocoder::Result::Google
  BOUNDING_BOX_KEYS = [:north_lat, :east_lng, :south_lat, :west_lng].freeze

  def bounding_box( order = BOUNDING_BOX_KEYS )
    coordinates = map_box_keys_to_values
    order.map{ |key| coordinates[key] }
  end

  private

  def extract_bounding_box
    bounds = geometry["bounds"]
    [
      bounds["northeast"]["lat"], # :north_lat
      bounds["northeast"]["lng"], # :east_lng
      bounds["southwest"]["lat"], # :south_lat
      bounds["southwest"]["lng"], # :west_lng
    ]
  end

  # Map the BOUNDING_BOX_KEYS to the associated values
  # Returns hash as:
  # {
  #   north_lat: 39.0464399, east_lng: -76.9836289,
  #   south_lat: 38.995162,  west_lng: -77.033157
  # }
  def map_box_keys_to_values
    Hash[*BOUNDING_BOX_KEYS.zip(extract_bounding_box).flatten]
  end
end

module Fetcher
  class MapQuestTraffic < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    LOCATION_URL  = "http://www.mapquestapi.com/geocoding/v1"
    ADDRESS_URI   = "/address"
    INCIDENTS_URI = "/incidents"

    base_uri "http://www.mapquestapi.com/traffic/v1"
    format :json

    def fetch
      @data = http_request(INCIDENTS_URI, traffic_options) do |data|
        data["incidents"].count{ |incident| incident["severity"] == 4 }
      end
    end

    private
    def find_zip_bounding_box
      order = [:north_lat, :west_lng, :south_lat, :east_lng]
      Geocoder.search(@cue)[0].bounding_box order
    end

    def address_options
      as_query location: @cue
    end

    def traffic_options
      as_query boundingBox: find_zip_bounding_box.join(','),
               filters:     :incidents,
               outFormat:   :json
    end

    def as_query( options )
      {
        query: { key: self.class.API_Key }.merge(options)
      }
    end
  end
end
