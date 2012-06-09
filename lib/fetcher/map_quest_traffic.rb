require 'geocoder'
require 'geocoder/ext/result_google'
require 'api_key'

module Fetcher
  class MapQuestTraffic < Base
    include APIKey

    api_key_param_name :key

    TRAFFIC_INCIDENTS_URI = "/incidents"

    base_uri "http://www.mapquestapi.com/traffic/v1"
    format :json

    add_fetcher_options after: :count_severe_incidents

    def uri
      TRAFFIC_INCIDENTS_URI
    end

    private
    def zip_geocode_data
      results = Geocoder.search(@cue)[0]
      results.is_zip? ? results : Geocoder.search(results.extract_zip)[0]
    end

    def bounding_box( order )
      zip_geocode_data.bounding_box(order).join(',')
    end

    def options
      order = [:north_lat, :west_lng, :south_lat, :east_lng]
      wrap_query_options api_key_option.merge boundingBox: bounding_box(order),
                                              filters:     :incidents,
                                              outFormat:   :json
    end

    def count_severe_incidents
        @data[:incidents].count{ |incident| incident[:severity] == 4 }
    end
  end
end
