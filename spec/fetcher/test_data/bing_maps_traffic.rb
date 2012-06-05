require 'json'

module Fetcher
  module TestData
    class BingMapsTraffic

      def self.data_with_0_severe_incidents
        TRAFFIC_DATA.dup
      end

      def self.data_with_1_severe_incidents
        data = TRAFFIC_DATA.dup
        incident = INCIDENT.dup
        incident["severity"] = 4
        data["resourceSets"][0]["resources"] = [incident]
        data
      end

      def self.data_with_5_severe_incidents
        data = TRAFFIC_DATA.dup
        incident = INCIDENT.dup
        incident["severity"] = 4
        data["resourceSets"][0]["resources"] = [incident] * 5
        data
      end

      BOUNDING_BOX = [
        38.75956821688915,
        -77.3123837106838,
        39.04903178311085,
        -76.9404162893162
      ].freeze

      ZIP_DATA = {
        "resourceSets" => [
          {
            "estimatedTotal" => 1,
            "resources" => [
              {
                "bbox" => BOUNDING_BOX,
                "name" => "United States",
                "point" => {
                  "type" => "Point",
                  "coordinates" => [
                     38.9043,
                     -77.1264
                  ]
                },
                "address" => {
                  "countryRegion" => "United States",
                  "formattedAddress" => "United States",
                },
                "entityType" => "Sovereign",
                "geocodePoints" => [
                  {
                    "type" => "Point",
                    "coordinates" => [
                     38.9043,
                     -77.1264
                    ],
                    "calculationMethod" => "Rooftop",
                    "usageTypes" => [
                      "Display"
                    ]
                  },
                  {
                    "type" => "Point",
                    "coordinates" => [
                     38.9043,
                     -77.1264
                    ],
                    "calculationMethod" => "Interpolation",
                    "usageTypes" => [
                      "Route"
                    ]
                  }
                ],
                "matchCodes" => [
                  "Good",
                  "UpHierarchy"
                ]
              }
            ]
          }
        ],
        "statusCode" => 200,
        "statusDescription" => "OK",
        "traceId" => "b0b1286504404eafa7e7dad3e749d570"
      }.freeze

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

