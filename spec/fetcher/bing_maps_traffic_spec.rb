require 'spec_helper'
require_relative 'test_data/bing_maps_traffic'
require_relative 'test_data/geocode'

module Fetcher
  describe BingMapsTraffic do
    describe "#fetch" do
      before(:each) do
        BingMapsTraffic.api_key = api_key
      end

      let( :api_key      ) { "arandomkey".freeze }
      let( :params       ) {{
          key:      api_key,
          severity: 4,
          o:        "json",
      }.freeze }

      def stub_incident_data( incident_count )
        data = TestData::BingMapsTraffic.send "data_with_#{incident_count}_severe_incidents"
        url = "http://dev.virtualearth.net/REST/v1/Traffic/Incidents/38.75956821688915,-77.3123837106838,39.04903178311085,-76.9404162893162"

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

          bing_maps = BingMapsTraffic.new zip_code

          bing_maps.fetch.should == count
          bing_maps.data.should == count
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

          bing_maps = BingMapsTraffic.new address

          bing_maps.fetch.should == 1
          bing_maps.data.should == 1
        end
      end
    end
  end
end

