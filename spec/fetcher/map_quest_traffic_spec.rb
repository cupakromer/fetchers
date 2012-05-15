require 'spec_helper'

module Fetcher
  describe MapQuestTraffic do
    describe "#fetch" do
      before(:each) do
        location_url = ""
        stub_request(:get, location_url).to_return(body: nil)

        traffic_url = ""
        stub_request(:get, traffic_url).to_return(body: nil)
      end

      [
        [22102, 0],
        ["22207", 1],
        [21201, 5],
      ].each do |zip_code, count|
        it "returns a count of #{count} severe traffic incidents"
      end
    end
  end
end
