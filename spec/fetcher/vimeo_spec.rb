require 'spec_helper'
require_relative 'test_data/vimeo'

module Fetcher
  describe Vimeo do
    describe "#fetch" do
      before(:each) do
        url = "http://vimeo.com/api/v2/channel/TestChannel/videos.json"

        stub_request(:get, url).to_return(body: TestData::Vimeo::JSON_DATA)
      end

      let( :channel            ) { "TestChannel"     }
      let( :vimeo_test_channel ) { Vimeo.new channel }

      it "returns data about the most recent video" do
        vimeo_test_channel.fetch.should == TestData::Vimeo::EXPECTED_DATA
      end

      it "sets the data about the most recent video to reader :data" do
        vimeo_test_channel.fetch
        vimeo_test_channel.data.should == TestData::Vimeo::EXPECTED_DATA
      end
    end
  end

end
