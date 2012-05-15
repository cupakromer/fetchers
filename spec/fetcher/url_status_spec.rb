require 'spec_helper'

module Fetcher
  describe UrlStatus do
    ANY_VALID_URL = "http://www.bing.com"
    let( :urlstatus ) { UrlStatus.new ANY_VALID_URL }

    context "Successful Request" do
      [
        HTTP_OK,
        HTTP_CREATED,
        HTTP_ACCEPTED,
        HTTP_NON_AUTHORITATIVE,
        HTTP_NO_CONTENT,
        HTTP_RESET_CONTENT,
      ].each do |code, message|
        it "return { available: true } on #{code}" do
          stub_request(:get, ANY_VALID_URL).to_return(status: [code, message])

          urlstatus.fetch.should == { available: true }
        end
      end
    end

    context "Unsuccessful Request" do
    end
  end
end
