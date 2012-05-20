require 'geocoder'

module Fetcher
  class BingMapsTraffic < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    API_URL  = "http://dev.virtualearth.net/REST/v1"
    ADDRESS_URI   = "/Locations"
    INCIDENTS_URI = "/Traffic/Incidents"

    base_uri API_URL
    format :json

    def fetch
      @data = http_request(INCIDENTS_URI + "/#{find_bounding_box_from_zip}", traffic_options) do |data|
        data["resourceSets"][0]["resources"].count{ |incident| incident["severity"] == 4 }
      end
    end

    private
    def find_bounding_box_from_zip
      location = http_request ADDRESS_URI, address_options
      box = location["resourceSets"][0]["resources"][0]["bbox"]

      south_lat, west_lng, north_lat, east_lng = *box

      # lower left, upper right
      [south_lat, west_lng, north_lat, east_lng].join ','
    end

    def address_options
      {
        query: {
          key:   self.class.API_Key,
          query: @cue
        }
      }
    end

    def traffic_options
      {
        query: {
          key:      self.class.API_Key,
          severity: 4,
          o:        "json",
        }
      }
    end
  end
end
