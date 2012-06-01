require 'spec_helper'
require_relative 'test_data/map_quest_traffic'
require 'json'

module Fetcher
  describe MapQuestTraffic do
    describe "#fetch" do
      before(:each) do
        @api_key = "arandomkey"
        @location_url = "http://www.mapquestapi.com/geocoding/v1/address"
        @traffic_url  = "http://www.mapquestapi.com/traffic/v1/incidents"

        @params = {
          key: @api_key,
        }
        @geocode_data = <<DATA
{
   "results" : [
      {
         "formatted_address" : "US City, Some place, USA",
         "geometry" : {
            "bounds" : {
               "northeast" : {
                  "lat" : 39.04903178311085,
                  "lng" : -76.9404162893162
               },
               "southwest" : {
                  "lat" : 38.75956821688915,
                  "lng" : -77.3123837106838
               }
            }
         },
         "types" : [ "postal_code" ]
      }
   ],
   "status" : "OK"
}
DATA
      end

      [
        [22102, 0],
        ["22207", 1],
        [21201, 5],
      ].each do |zip_code, count|
        it "#{zip_code} returns a count of #{count} severe traffic incidents" do

          stub_request(:get,
          "http://maps.googleapis.com/maps/api/geocode/json").
            with(query: {address: zip_code, language: :en, sensor: :false}).
            to_return(body: @geocode_data)

          stub_request(:get, @traffic_url).
            with(query: {
              key: @api_key,
              boundingBox: TestData::MapQuestTraffic::BOUNDING_BOX.join(','),
              filters: :incidents,
              outFormat: :json
            }).
            to_return(body: JSON.generate(TestData::MapQuestTraffic.send "data_with_#{count}_severe_incidents"))

          MapQuestTraffic.API_Key = @api_key
          map_quest = MapQuestTraffic.new zip_code

          map_quest.fetch.should == count
          map_quest.data.should == count
        end
      end
    end
  end
end
