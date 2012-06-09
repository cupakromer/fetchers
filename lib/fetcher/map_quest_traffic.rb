require 'api_key'
require_relative 'basic_traffic'

module Fetcher
  class MapQuestTraffic < BasicTraffic
    include APIKey

    api_key_param_name :key

    TRAFFIC_INCIDENTS_URI = "/incidents"

    base_uri "http://www.mapquestapi.com/traffic/v1"
    format :json

    def uri
      TRAFFIC_INCIDENTS_URI
    end

    private
    def options
      order = [:north_lat, :west_lng, :south_lat, :east_lng]
      wrap_query_options api_key_option.merge boundingBox: bounding_box(order),
                                              filters:     :incidents,
                                              outFormat:   :json
    end

    def extract_incidents( json_data )
        json_data[:incidents]
    end
  end
end
