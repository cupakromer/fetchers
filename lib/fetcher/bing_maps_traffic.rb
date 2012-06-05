require 'geocoder'
require 'geocoder/ext/result_google'
require 'api_key'

module Fetcher
  class BingMapsTraffic < Base
    include APIKey

    api_key_param_name :key

    TRAFFIC_INCIDENTS_URI = "/Traffic/Incidents"

    base_uri "http://dev.virtualearth.net/REST/v1"
    format :json

    def fetch
      @data = http_request(traffic_incident_uri, traffic_options) do |data|
        count_severe_incidents data
      end
    end

    private
    def traffic_incident_uri
      order = [:south_lat, :west_lng, :north_lat, :east_lng]
      TRAFFIC_INCIDENTS_URI + "/#{find_zip_bounding_box order}"
    end

    def find_zip_bounding_box( order )
      Geocoder.search(@cue)[0].bounding_box(order).join(',')
    end

    def traffic_options
      as_query severity: 4, o: "json"
    end

    def as_query( options )
      {
        query: api_key_option.merge(options)
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
