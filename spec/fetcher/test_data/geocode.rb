require 'spec_helper'

module Fetcher
  module TestData
    module Geocode
      ZIP_DATA = File.read("#{File.dirname __FILE__}/geocode_zip_data.json").freeze

      ADDRESS_DATA = File.read("#{File.dirname __FILE__}/geocode_address_data.json").freeze

      def self.stub_request( test, address )
        test.stub_request(:get, "http://maps.googleapis.com/maps/api/geocode/json").
          with(query: {address: address, language: :en, sensor: :false}).
          to_return(body: yield)
      end
    end
  end
end
