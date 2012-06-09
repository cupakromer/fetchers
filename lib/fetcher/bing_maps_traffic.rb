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

    add_fetcher_options after: :count_severe_incidents

    private
    def uri
      order = [:south_lat, :west_lng, :north_lat, :east_lng]
      TRAFFIC_INCIDENTS_URI + "/#{bounding_box order}"
    end

    def bounding_box( order )
      zip_geocode_data.bounding_box(order).join(',')
    end

    def zip_geocode_data
      results = Geocoder.search(@cue)[0]
      results.is_zip? ? results : Geocoder.search(results.extract_zip)[0]
    end

    def options
      wrap_query_options api_key_option.merge severity: 4, o: "json"
    end

    def count_severe_incidents
      get_incidents(@data).count{ |incident| incident[:severity] == 4 }
    end

    def get_incidents( incident_response_body )
      incident_response_body[:resourceSets][0][:resources]
    end
  end
end
