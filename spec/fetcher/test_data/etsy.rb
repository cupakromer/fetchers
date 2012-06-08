require 'json'

module Fetcher
  module TestData
    module Etsy
      JSON_DATA = File.read("#{File.dirname __FILE__}/etsy.json").freeze

      EXPECTED_DATA = [
        {
          title:         "Deathly Hallows Necklace",
          price:         "48.00",
          currency_code: "USD",
          url:           "http://www.etsy.com/listing/69050819",
          ending_tsz:    1347249600,
        },
        {
          title:         "Elder Wand",
          price:         "12.91",
          currency_code: "AUD",
          url:           "http://www.etsy.com/listing/76354276",
          ending_tsz:    1347249600,
        },
        {
          title:         "Resurrection Stone",
          price:         "12.91",
          currency_code: "AUD",
          url:           "http://www.etsy.com/listing/76155481",
          ending_tsz:    1347249600,
        },
        {
          title:         "Cloak",
          price:         "11.91",
          currency_code: "AUD",
          url:           "http://www.etsy.com/listing/76210705",
          ending_tsz:    1347249600,
        },
        {
          title:         "Time Turner",
          price:         "2.99",
          currency_code: "USD",
          url:           "http://www.etsy.com/listing/96592867",
          ending_tsz:    1347249600,
        }
      ].freeze
    end
  end
end
