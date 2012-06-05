require 'geocoder'
require 'geocoder/ext/result_google'

module Fetcher
  class BingMapsTraffic < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    INCIDENTS_URI = "/Traffic/Incidents"

    base_uri "http://dev.virtualearth.net/REST/v1"
    format :json

    def fetch
      @data = http_request(bounding_box_uri, traffic_options) do |data|
        count_severe_incidents data
      end
    end

    private
    def bounding_box_uri
      INCIDENTS_URI + "/#{find_bounding_box_from_zip}"
    end

    def find_bounding_box_from_zip
      order = [:south_lat, :west_lng, :north_lat, :east_lng]
      Geocoder.search(@cue)[0].bounding_box(order).join ','
    end

    def traffic_options
      as_query severity: 4, o: "json"
    end

    def as_query( options )
      {
        query: { key: self.class.API_Key }.merge(options)
      }
    end

    def count_severe_incidents( response_body )
      get_incidents(response_body).count{ |incident| incident["severity"] == 4 }
    end

    def get_incidents( incident_response_body )
      incident_response_body["resourceSets"][0]["resources"]
    end
  end
end
