module Fetcher
  module TestData
    module Geocode
      ZIP_DATA = File.read("#{File.dirname __FILE__}/geocode_zip_data.json").freeze

      ADDRESS_DATA = File.read("#{File.dirname __FILE__}/geocode_address_data.json").freeze
    end
  end
end
