require 'spec_helper'
require_relative 'test_data/map_quest_traffic'

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
      end

      [
        [22102, 0],
        ["22207", 1],
        [21201, 5],
      ].each do |zip_code, count|
        it "#{zip_code} returns a count of #{count} severe traffic incidents" do

          stub_request(:get, @location_url).
            with(query: {key: @api_key, location: zip_code}).
            to_return(body: TestData::MapQuestTraffic::ZIP_DATA)

          stub_request(:get, @traffic_url).with(query: {}).
            with(query: {key: @api_key, boundingBox: TestData::MapQuestTraffic::BOUNDING_BOX, filters: :incidents, outFormat: :json}).
            to_return(body: TestData::MapQuestTraffic.data_with_0_severe_incidents)

          MapQuestTraffic.API_Key = @api_key
          map_quest = MapQuestTraffic.new zip_code

          map_quest.fetch.should == count
          map_quest.data.should == count
        end
      end
    end
  end
end
