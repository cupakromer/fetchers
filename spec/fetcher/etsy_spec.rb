require 'spec_helper'
require_relative 'test_data/etsy'

module Fetcher
  describe Etsy do
    describe "#fetch" do
      before(:each) do
        url = "http://openapi.etsy.com/v2/listings/active"

        params = {
          api_key:    "random_api_key",
          limit:      5,
          sort_on:    "created",
          sort_order: "down",
          keywords:   "harry,potter",
          fields:     "title,price,currency_code,url,ending_tsz",
        }

        stub_request(:get, url).with(query: params).
          to_return(body: TestData::Etsy::JSON_DATA)
      end

      let( :etsy_active_items ) {
        keywords = "harry potter"

        Etsy.API_Key = "random_api_key"

        Etsy.new keywords
      }

      it "returns data about the five most recent items" do
        etsy_active_items.fetch.should == TestData::Etsy::EXPECTED_DATA
      end

      it "sets the data about the most recent items to reader :data" do
        etsy_active_items.fetch
        etsy_active_items.data.should == TestData::Etsy::EXPECTED_DATA
      end
    end
  end
end
