require 'spec_helper'

module Fetcher
  describe Base do
    ANY_VALID_URL = "http://www.bing.com"

    let( :empty_cue  ) { [].freeze          }
    let( :base       ) { Base.new empty_cue }

    describe "new object" do
      it "should return false on #success?" do
        base.success?.should == false
      end

      it "should return \"\" on #message" do
        base.message.should be_empty
      end
    end

    describe "#success?" do
      it "returns the status of the last http request" do
        base.should_receive(:last_request_status)

        base.success?
      end
    end

    describe "#http_request" do
      # Normally private methods are not tested. However, since this method is
      # such a work-horse for the class, it needs to be tested.

      [
        "http://www.google.com",
        "http://bing.com/ajax",
        "http://random.url.subdomain.net/test/api/tmp.json",
        "https://www.bing.com/stuff"
      ].each do |url|
        it "should make an HTTP request to the provided URL #{url}" do
          stub_request(:get, url)

          base.send :http_request, url
        end
      end

      it "should cause #success? to be true on a HTTP OK response" do
        stub_request(:get, ANY_VALID_URL).to_return(status: HTTP_OK)

        base.send :http_request, ANY_VALID_URL
        base.success?.should be_true
      end

      describe "#message" do
        [
          [HTTP_OK, "Request succeeded"],
          [HTTP_BAD_REQUEST, "HTTP request failed for #{ANY_VALID_URL}: 'Bad Request'"],
          [HTTP_FORBIDDEN, "HTTP request failed for #{ANY_VALID_URL}: 'Forbidden'"],
          [HTTP_INTERNAL_SERVER_ERROR, "HTTP request failed for #{ANY_VALID_URL}: 'Internal Server Error'"]
        ].each do |http_response, expected|
          it "returns #{expected} on a HTTP #{http_response[0]} response" do
            stub_request(:get, ANY_VALID_URL).to_return(status: http_response)

            base.send :http_request, ANY_VALID_URL

            base.message.should == expected
          end
        end
      end

      it "will call the provided block with the response body on HTTP OK" do
        stub_request(:get, ANY_VALID_URL).to_return(body: "BODY DATA")

        data = ""
        base.send(:http_request, ANY_VALID_URL) do |body|
          data = body
        end

        data.should == "BODY DATA"
      end
    end
  end
end
