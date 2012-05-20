require 'spec_helper'
require_relative 'test_data/bing_maps_traffic'
require 'json'

module Fetcher
  describe BingMapsTraffic do
    describe "#fetch" do
      before(:each) do
        @api_key = "arandomkey"

        # http://dev.virtualearth.net/REST/v1/Locations/US/adminDistrict/postalCode/locality/addressLine?includeNeighborhood=includeNeighborhood&maxResults=maxResults&key=BingMapsKey
        # Ex. http://dev.virtualearth.net/REST/v1/Locations?query=22102&key=arandomkey
        @location_url = "http://dev.virtualearth.net/REST/v1/Locations"

        # Ex. http://dev.virtualearth.net/REST/v1/Traffic/Incidents/37,-105,45,-94?s=4&o=json&key=arandomkey
        @traffic_url  = "http://dev.virtualearth.net/REST/v1/Traffic/Incidents"

        @params = {
          key:      @api_key,
          severity: 4,
          o:        "json",
        }
      end

      [
        [22102, 0],
        ["22207", 1],
        [21201, 5],
      ].each do |zip_code, count|
        it "#{zip_code} returns a count of #{count} severe traffic incidents" do

          stub_request(:get, @location_url).
            with(query: {key: @api_key, query: zip_code}).
            to_return(body: JSON.generate(TestData::BingMapsTraffic::ZIP_DATA))

          stub_request(:get, @traffic_url + "/#{TestData::BingMapsTraffic::BOUNDING_BOX.join ','}").
            with(query: @params).
            to_return(body: JSON.generate(TestData::BingMapsTraffic.send "data_with_#{count}_severe_incidents"))

          BingMapsTraffic.API_Key = @api_key
          map_quest = BingMapsTraffic.new zip_code

          map_quest.fetch.should == count
          map_quest.data.should == count
        end
      end
    end
  end
end

