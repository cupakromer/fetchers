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
      [
        HTTP_BAD_REQUEST,
        HTTP_FORBIDDEN,
        HTTP_INTERNAL_SERVER_ERROR,
      ].each do |code, message|
        it "return { available: false } on #{code}" do
          stub_request(:get, ANY_VALID_URL).to_return(status: [code, message])

          urlstatus.fetch.should == { available: false }
        end
      end

      [
        HTTParty::RedirectionTooDeep,
        HTTParty::ResponseError,
        SocketError,
        Timeout::Error
      ].each do |exception|
        it "return { available: false } on exception #{exception}" do
          stub_request(:get, ANY_VALID_URL).to_raise(exception)

          urlstatus.fetch.should == { available: false }
        end
      end
    end
  end
end
