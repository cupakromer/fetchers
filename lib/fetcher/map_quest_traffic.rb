require 'geocoder'

module Fetcher
  class MapQuestTraffic < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    LOCATION_URL  = "http://www.mapquestapi.com/geocoding/v1"
    ADDRESS_URI   = "/address"
    TRAFFIC_URL   = "http://www.mapquestapi.com/traffic/v1"
    INCIDENTS_URI = "/incidents"

    base_uri TRAFFIC_URL
    format :json

    def fetch
      @data = http_request(INCIDENTS_URI, traffic_options) do |data|
        data["incidents"].count{ |incident| incident["severity"] == 4 }
      end
    end

    private
    def find_bounding_box_for_zip
      location_data = http_request(LOCATION_URL + ADDRESS_URI, address_options)
      box = Geocoder::Calculations.bounding_box extract_lat_lng(location_data), 10

      s_lat, w_lng, n_lat, e_lng = *box

      [n_lat, w_lng, s_lat, e_lng]
    end

    def extract_lat_lng location_data
      lat_lng = location_data["results"][0]["locations"][0]["latLng"]
      [lat_lng["lat"], lat_lng["lng"]]
    end

    def address_options
      {
        query: {
          key:      self.class.API_Key,
          location: @cue.to_s
        }
      }
    end

    def traffic_options
      {
        query: {
          key:         self.class.API_Key,
          boundingBox: find_bounding_box_for_zip.join(','),
          filters:     :incidents,
          outFormat:   :json
        }
      }
    end
  end
end
