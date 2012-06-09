require 'api_key'
require_relative 'basic_traffic'

module Fetcher
  class BingMapsTraffic < BasicTraffic
    include APIKey

    api_key_param_name :key

    TRAFFIC_INCIDENTS_URI = "/Traffic/Incidents"

    base_uri "http://dev.virtualearth.net/REST/v1"
    format :json

    def uri
      order = [:south_lat, :west_lng, :north_lat, :east_lng]
      TRAFFIC_INCIDENTS_URI + "/#{bounding_box order}"
    end

    private
    def options
      wrap_query_options api_key_option.merge severity: 4, o: "json"
    end

    def extract_incidents( incident_response_body )
      incident_response_body[:resourceSets][0][:resources]
    end
  end
end
