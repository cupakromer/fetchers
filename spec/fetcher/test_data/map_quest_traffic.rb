require 'json'

module Fetcher
  module TestData
    class MapQuestTraffic

      def self.data_with_0_severe_incidents
        data = TRAFFIC_DATA.dup
        data["incidents"] = []
        data
      end

      def self.data_with_1_severe_incidents
        data = TRAFFIC_DATA.dup
        data["incidents"] = INCIDENTS.first { |incident|
          incident["severity"] == 4
        }
        data
      end

      def self.data_with_5_severe_incidents
        data = TRAFFIC_DATA.dup
        data["incidents"] = INCIDENTS.select { |incident|
          incident["severity"] == 4
        }[0...5]
        data
      end

      ZIP_DATA = {
        "results" => [
          {
            "locations" => [
              {
                "latLng" => { "lng" => -77.1264, "lat" => 38.9043 },
                "displayLatLng" => { "lng" => -77.1264, "lat" => 38.9043 },
                "geocodeQuality" => "ZIP",
              }
            ],
          }
        ],
        "info" => {
          "statuscode" => 0,
          "messages" => []
        }
      }.freeze

      BOUNDING_BOX = [39.04903178311085, -76.9404162893162, 38.75956821688915, -77.3123837106838].freeze

      INCIDENTS = [
        {
          "fullDesc" => "In ARAPAHOE accident on BELLEVIEW between US 85/S SANTA FE DR and HWY 88/S FEDERAL BLVD",
          "lng" => -105.0254,
          "severity" => 1,
          "shortDesc" => "Accident(s) on BELLEVIEW between US 85/S SANTA FE DR and HWY 88/S FEDERAL BLVD",
          "endTime"=> "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789251873",
          "startTime" => "2012-05-15T18:46:47",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.62412,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In DENVER accident on 6TH AVE. (CENTRAL) near BROADWAY",
          "lng" => -104.9875,
          "severity" => 4,
          "shortDesc" => "Accident(s) on 6TH AVE. (CENTRAL) at BROADWAY",
          "endTime" => "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789285119",
          "startTime" => "2012-05-15T19:08:41",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.72564,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In DENVER accident on HWY 85/SANTA FE SB after I-25",
          "lng" => -104.9955,
          "severity" => 1,
          "shortDesc" => "Accident(s) on HWY 85/SANTA FE southbound at I-25",
          "endTime" => "2012-05-15T20:07:03",
          "type" => 4,
          "id" => "1789288851",
          "startTime" => "2012-05-15T19:09:01",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.70451,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In DENVER accident on E 1ST AVE between STEELE ST and JOSEPHINE ST",
          "lng" => -104.9591,
          "severity" => 1,
          "shortDesc" => "Accident(s) on E 1ST AVE between STEELE ST and JOSEPHINE ST",
          "endTime" => "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789294371",
          "startTime" => "2012-05-15T19:13:43",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.71834,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In ARAPAHOE accident. right lane blocked on HWY 285/HAMPDEN WB at HWY 88/FEDERAL BLVD",
          "lng" => -105.0253,
          "severity" => 2,
          "shortDesc" => "Accident. Right lane blocked on HWY 285/HAMPDEN westbound at HWY 88/FEDERAL BLVD",
          "endTime" => "2012-05-15T20:52:02",
          "type" => 4,
          "id" => "1789302797",
          "startTime" => "2012-05-15T19:19:31",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.65216,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_mod.png"
        },
        {
          "fullDesc" => "In AURORA accident on E ILIFF AVE EB after I 225",
          "lng" => -104.8288,
          "severity" => 4,
          "shortDesc" => "Accident(s) on E ILIFF AVE eastbound at I 225",
          "endTime" => "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789308647",
          "startTime" => "2012-05-15T19:22:46",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.67481,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In DENVER stop and go traffic on I 25 NB between 6TH AVE and 48TH AVE due to disabled vehicle. left lane blocked",
          "lng" => -104.9892,
          "severity" => 3,
          "shortDesc" => "Disabled vehicle. Left lane blocked on I 25 northbound between 6TH AVE and 48TH AVE",
          "endTime" => "2012-05-15T20:07:01",
          "type" => 4,
          "id" => "1789311029",
          "startTime" => "2012-05-15T19:25:34",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.78409,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_mod.png"
        },
        {
          "fullDesc" => "In DENVER slow traffic on I-70 WB between PEORIA ST and PECOS ST due to accident",
          "lng" => -105.0064,
          "severity" => 2,
          "shortDesc" => "Accident(s) on I-70 westbound between PEORIA ST and PECOS ST",
          "endTime" => "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789319009",
          "startTime" => "2012-05-15T19:30:46",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.78312,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_mod.png"
        },
        {
          "fullDesc" => "In DENVER construction on HWY 85/SANTA FE BOTH NB/SB at I-25",
          "lng" => -104.9955,
          "severity" => 0,
          "shortDesc" => "On-ramp closed on HWY 85/SANTA FE both directions at I-25",
          "endTime" => "2012-05-16T07:23:32",
          "type" => 4,
          "id" => "1787654499",
          "startTime" => "2012-05-15T07:13:32",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.70451,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In AURORA accident on E SMOKY HILL RD east of HWY E 470",
          "lng" => -104.7141,
          "severity" => 1,
          "shortDesc" => "Accident(s) on E SMOKY HILL RD at HWY E 470",
          "endTime" => "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789186343",
          "startTime" => "2012-05-15T18:11:06",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.60106,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In ARAPAHOE accident on UNIVERSITY BLVD at HWY 88/BELLEVIEW PL",
          "lng" => -104.9598,
          "severity" => 1,
          "shortDesc" => "Accident(s) on UNIVERSITY BLVD at HWY 88/BELLEVIEW PL",
          "endTime" => "2012-05-15T20:07:03",
          "type" => 4,
          "id" => "1789194675",
          "startTime" => "2012-05-15T18:16:08",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.62423,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In DENVER closed due to accident on FEDERAL BLVD NB after FLORIDA AVE",
          "lng" => -105.025,
          "severity" => 4,
          "shortDesc" => "Road closed due to  accident(s) on FEDERAL BLVD northbound at FLORIDA AVE",
          "endTime" => "2012-05-15T20:07:00",
          "type" => 4,
          "id" => "1789218485",
          "startTime" => "2012-05-15T18:28:41",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.68948,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_sev.png"
        },
        {
          "fullDesc" => "In DENVER accident on S MONACO PKWY at HWY 83/LEETSDALE DR",
          "lng" => -104.9129,
          "severity" => 4,
          "shortDesc" => "Accident(s) on S MONACO PKWY at HWY 83/LEETSDALE DR",
          "endTime" => "2012-05-15T20:07:03",
          "type" => 4,
          "id" => "1789242657",
          "startTime" => "2012-05-15T18:41:41",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.70291,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        },
        {
          "fullDesc" => "In DOUGLAS accident on E COUNTY LINE RD WB after S YOSEMITE ST",
          "lng" => -104.8858,
          "severity" => 1,
          "shortDesc" => "Accident(s) on E COUNTY LINE RD westbound at S YOSEMITE ST",
          "endTime" => "2012-05-15T20:07:02",
          "type" => 4,
          "id" => "1789259281",
          "startTime" => "2012-05-15T18:51:48",
          "impacting" => true,
          "eventCode" => 0,
          "lat" => 39.56589,
          "iconURL" => "http://api.mqcdn.com/mqtraffic/incid_min.png"
        }
      ].freeze

      TRAFFIC_DATA = {
        "incidents" => [
        ],
        "mqURL" => "http://www.mapquest.com/maps?traffic=1&latitude=39.7397611&longitude=-104.984793",
        "info" =>  {
          "statuscode" => 0,
          "messages" => []
        }
      }.freeze
    end
  end
end
