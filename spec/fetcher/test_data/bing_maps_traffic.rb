require 'json'

module Fetcher
  module TestData
    module BingMapsTraffic

      def self.method_missing( method, *args, &block )
        case method
        when /^data_with_(?<incident_count>\d+)_(?<severity>\w+)_incidents$/
          data = TRAFFIC_DATA.dup
          incident_count = $~[:incident_count].to_i
          if incident_count > 0
            incident = INCIDENT.dup
            incident["severity"] = 4
            data["resourceSets"][0]["resources"] = [incident] * incident_count
          end
          JSON.generate data
        else
          super
        end
      end

      INCIDENT = {
        "point" => {
          "type" => "Point",
          "coordinates" => [39.09313,-94.64932]
        },
        "description" => "ramp to EB I-70 is closed due to construction",
        "end" => "\/Date(1346670060000)\/",
        "incidentId" => 307118340,
        "lastModified" => "\/Date(1337189504000)\/",
        "roadClosed" => true,
        "start" => "\/Date(1336991460000)\/",
        "type" => 9,
        "verified" => true
      }.freeze

      TRAFFIC_DATA = {
        "resourceSets" => [
          {
            "estimatedTotal" => 2,
            "resources" => []
          }
        ],
        "statusCode" => 200,
        "statusDescription" => "OK"
      }.freeze
    end
  end
end

