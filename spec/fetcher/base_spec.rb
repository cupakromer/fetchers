require 'spec_helper'

module Fetcher
  describe Base do
    EMPTY_CUE = []

    describe "#success?" do
      it "returns the status of the last http request" do
        b = Base.new EMPTY_CUE

        b.should_receive(:last_request_status)

        b.success?
      end
    end

    describe "#fetch" do
      it "raises a must be implemented by child class error" do
        b = Base.new EMPTY_CUE

        expect { b.fetch }.to raise_error "Must be implemented by child class"
      end
    end

    describe "#http_request" do
      # Normally private methods are not tested. However, since this method is
      # such a work-horse for the class, it needs to be tested.

      [
        "http://www.google.com",
        "http://bing.com/ajax",
        "http://random.url.subdomain.net/test/api/tmp.json"
      ].each do |url|
        it "should make an HTTP request to the provided URL #{url}" do
          # TODO: Learn to fake the internet itself
          # This is a very brittle test
          Net::HTTP.should_receive(:get_response).with(URI url).
            and_return double("response").as_null_object

          b = Base.new EMPTY_CUE
          b.send :http_request, url
        end
      end

      ANY_VALID_URL = "http://www.bing.com"
      it "should cause #success? to be true when it gets a 200 response" do
        Net::HTTP.stub(:get_response).with(URI ANY_VALID_URL).
          and_return Net::HTTPOK.new "1.1", "200", "OK"

        b = Base.new EMPTY_CUE
        b.send :http_request, ANY_VALID_URL
        b.success?.should be_true
      end
    end
  end
end
