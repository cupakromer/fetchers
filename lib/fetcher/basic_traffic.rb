require 'geocoder'
require 'geocoder/ext/result_google'

module Fetcher
  class BasicTraffic < Base
    add_fetcher_options after: :count_severe_incidents

    def self.inherited( subclass )
      subclass.add_fetcher_options after: :count_severe_incidents
      super
    end

    private
    def bounding_box( order )
      zip_geocode_data.bounding_box(order).join(',')
    end

    def zip_geocode_data
      results = Geocoder.search(@cue)[0]
      results.is_zip? ? results : Geocoder.search(results.extract_zip)[0]
    end

    def count_severe_incidents
      extract_incidents(@data).count{ |incident| incident[:severity] == 4 }
    end

    def extract_incidents( incident_response_body )
      fail "Must be implemented by child class."
    end
  end
end
