require 'json'

module Fetcher
  module TestData
    class MapQuestTraffic

      def self.method_missing( method, *args, &block )
        case method
        when /^data_with_(?<incident_count>\d+)_(?<severity>\w+)_incidents$/
          data = TRAFFIC_DATA.dup
          incident_count = $~[:incident_count].to_i
          if incident_count > 0
            incident = INCIDENT.dup
            incident["severity"] = 4
            data["incidents"] = [incident] * incident_count
          end
          JSON.generate data
        else
          super
        end
      end

      INCIDENT = {
          "fullDesc" => "There was an accident on the road",
          "lng" => -105.0254,
          "severity" => 1,
          "shortDesc" => "Accident(s) on on the road between US 1 and HWY 8",
          "endTime"=> "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789251873",
          "startTime" => "2012-05-15T18:46:47",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.62412,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
      }.freeze

      TRAFFIC_DATA = {
        "incidents" => [],
        "mqURL" => "http://www.mapquest.com/maps?traffic=1&latitude=39.7397611&longitude=-104.984793",
        "info" =>  {
          "statuscode" => 0,
          "messages" => []
        }
      }.freeze
    end
  end
end
