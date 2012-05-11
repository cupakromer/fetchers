require 'spec_helper'
require 'json'

module Fetcher
  describe Etsy do
    describe "#fetch" do
      ITEMS_DATA = {
        count: 18417,
        results: [
          {
            title:                 "Deathly Hallows Necklace",
            listing_id:            69050819,
            price:                 "48.00",
            currency_code:         "USD",
            url:                   "http://www.etsy.com/listing/69050819",
            creation_tsz:          1336695841,
            ending_tsz:            1347249600,
            original_creation_tsz: 1298917887,
          },
          {
            title:                 "Elder Wand",
            listing_id:            76354276,
            price:                 "12.91",
            currency_code:         "AUD",
            url:                   "http://www.etsy.com/listing/76354276",
            creation_tsz:          1336695581,
            ending_tsz:            1347249600,
            original_creation_tsz: 1308612493,
          },
          {
            title:                 "Resurrection Stone",
            listing_id:            76155481,
            price:                 "12.91",
            currency_code:         "AUD",
            url:                   "http://www.etsy.com/listing/76155481",
            creation_tsz:          1336695581,
            ending_tsz:            1347249600,
            original_creation_tsz: 1308303884,
          },
          {
            title:                 "Cloak",
            listing_id:            76210705,
            price:                 "11.91",
            currency_code:         "AUD",
            url:                   "http://www.etsy.com/listing/76210705",
            creation_tsz:          1336695581,
            ending_tsz:            1347249600,
            original_creation_tsz: 1308389493,
          },
          {
            title:                 "Time Turner",
            listing_id:            96592867,
            price:                 "2.99",
            currency_code:         "USD",
            url:                   "http://www.etsy.com/listing/96592867",
            creation_tsz:          1336694671,
            ending_tsz:            1347249600,
            original_creation_tsz: 1333282416,
          }
        ],
        type: "Listing",
      }.freeze

      API_KEY = "random_api_key"
      KEYWORDS = "harry potter"
      ETSY_URL = "http://openapi.etsy.com/v2/listings/active?api_key=random_api_key&limit=5&sort_on=created&sort_order=down&keywords=harry,potter&fields=title,price,currency_code,url,ending_tsz".freeze

      ETSY_DATA = [
        {
          title:                 "Deathly Hallows Necklace",
          price:                 "48.00",
          currency_code:         "USD",
          url:                   "http://www.etsy.com/listing/69050819",
          ending_tsz:            1347249600,
        },
        {
          title:                 "Elder Wand",
          price:                 "12.91",
          currency_code:         "AUD",
          url:                   "http://www.etsy.com/listing/76354276",
          ending_tsz:            1347249600,
        },
        {
          title:                 "Resurrection Stone",
          price:                 "12.91",
          currency_code:         "AUD",
          url:                   "http://www.etsy.com/listing/76155481",
          ending_tsz:            1347249600,
        },
        {
          title:                 "Cloak",
          price:                 "11.91",
          currency_code:         "AUD",
          url:                   "http://www.etsy.com/listing/76210705",
          ending_tsz:            1347249600,
        },
        {
          title:                 "Time Turner",
          price:                 "2.99",
          currency_code:         "USD",
          url:                   "http://www.etsy.com/listing/96592867",
          ending_tsz:            1347249600,
        }
      ].freeze

      let( :json_data         ) { JSON.generate ITEMS_DATA }
      let( :etsy_active_items ) {
        Etsy.API_Key = API_KEY
        Etsy.new KEYWORDS
      }

      before(:each) do
        Net::HTTP.stub(:get_response).with(URI ETSY_URL).
          and_return Response.new *HTTP_OK, json_data
      end

      it "returns data about the five most recent items" do
        etsy_active_items.fetch.should == ETSY_DATA
      end

      it "sets the data about the most recent items to reader :data" do
        etsy_active_items.fetch
        etsy_active_items.data.should == ETSY_DATA
      end
    end
  end
end
