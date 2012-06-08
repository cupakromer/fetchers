require 'spec_helper'
require_relative 'test_data/map_quest_traffic'
require_relative 'test_data/geocode'

module Fetcher
  describe MapQuestTraffic do
    describe "#fetch" do

      before(:each) do
        MapQuestTraffic.api_key = api_key
      end

      let( :api_key ) { "arandomkey".freeze }
      let( :params  ) {{
        key:         api_key,
        boundingBox: "39.04903178311085,-77.3123837106838," \
                     "38.75956821688915,-76.9404162893162",
        filters:     :incidents,
        outFormat:   :json
      }.freeze }

      def stub_incident_data( incident_count )
        data = TestData::MapQuestTraffic.send "data_with_#{incident_count}_severe_incidents"
        url = "http://www.mapquestapi.com/traffic/v1/incidents"

        stub_request(:get, url).with(query: params).to_return(body: data)
      end

      [
        [22102, 0],
        ["22207", 1],
        [21201, 5],
      ].each do |zip_code, count|
        it "#{zip_code} returns a count of #{count} severe traffic incidents" do

          TestData::Geocode.stub_request(self, zip_code) do
            TestData::Geocode::ZIP_DATA
          end

          stub_incident_data count

          map_quest = MapQuestTraffic.new zip_code

          map_quest.fetch.should == count
          map_quest.data.should == count
        end
      end

      [
        "1234 Address Ln., City, State",
        "100 Made Up Dr., Apt #12",
      ].each do |address|
        it "#{address} returns a count of 1 severe traffic incidents" do

          TestData::Geocode.stub_request(self, address) do
            TestData::Geocode::ADDRESS_DATA
          end

          TestData::Geocode.stub_request(self, 10000) do
            TestData::Geocode::ZIP_DATA
          end

          stub_incident_data 1

          map_quest = MapQuestTraffic.new address

          map_quest.fetch.should == 1
          map_quest.data.should == 1
        end
      end
    end
  end
end
