require 'geocoder'
require 'geocoder/ext/result_google'

module Fetcher
  class MapQuestTraffic < Base
    @API_Key = nil
    class << self
      attr_accessor :API_Key
    end

    INCIDENTS_URI = "/incidents"

    base_uri "http://www.mapquestapi.com/traffic/v1"
    format :json

    def fetch
      @data = http_request(INCIDENTS_URI, traffic_options) do |data|
        count_sever_incidents data
      end
    end

    private
    def find_zip_bounding_box
      order = [:north_lat, :west_lng, :south_lat, :east_lng]
      Geocoder.search(@cue)[0].bounding_box order
    end

    def traffic_options
      as_query boundingBox: find_zip_bounding_box.join(','),
               filters:     :incidents,
               outFormat:   :json
    end

    def count_sever_incidents( response_body )
        response_body["incidents"].count{ |incident| incident["severity"] == 4 }
    end

    def as_query( options )
      {
        query: { key: self.class.API_Key }.merge(options)
      }
    end
  end
end
