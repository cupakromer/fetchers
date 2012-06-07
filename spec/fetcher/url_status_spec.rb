require 'spec_helper'

module Fetcher
  describe UrlStatus do
    let( :any_valid_url ) { "http://www.bing.com"       }
    let( :urlstatus     ) { UrlStatus.new any_valid_url }

    [
      [HTTP_OK, true],
      [HTTP_CREATED, true],
      [HTTP_ACCEPTED, true],
      [HTTP_NON_AUTHORITATIVE, true],
      [HTTP_NO_CONTENT, true],
      [HTTP_RESET_CONTENT, true],
      [HTTP_BAD_REQUEST, false],
      [HTTP_FORBIDDEN, false],
      [HTTP_INTERNAL_SERVER_ERROR, false],
    ].each do |status, expected_result|
      it "return { available: true } on #{status}" do
        stub_request(:get, any_valid_url).to_return(status: status)

        urlstatus.fetch.should == { available: expected_result }
        urlstatus.data.should  == { available: expected_result }
      end
    end

    [
      HTTParty::RedirectionTooDeep,
      HTTParty::ResponseError,
      SocketError,
      Timeout::Error
    ].each do |exception|
      it "return { available: false } on exception #{exception}" do
        stub_request(:get, any_valid_url).to_raise(exception)

        urlstatus.fetch.should == { available: false }
        urlstatus.data.should  == { available: false }
      end
    end

    it "times out after 30 seconds" do
      stub_request(:get, any_valid_url)

      urlstatus.should_receive(:http_request).with(any_valid_url, timeout: 30)
      urlstatus.fetch
    end
  end
end
