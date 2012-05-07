require 'spec_helper'

module Fetcher
  describe Base do
    EMPTY_CUE = []
    ANY_VALID_URL = "http://www.bing.com"

    let(:base) { Base.new EMPTY_CUE }

    describe "#success?" do
      it "returns the status of the last http request" do
        base.should_receive(:last_request_status)

        base.success?
      end
    end

    describe "#fetch" do
      it "raises a must be implemented by child class error" do
        expect{ base.fetch }.to raise_error "Must be implemented by child class"
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

          base.send :http_request, url
        end
      end

      it "should cause #success? to be true when it gets a 200 response" do
        Net::HTTP.stub(:get_response).with(URI ANY_VALID_URL).
          and_return Net::HTTPOK.new "1.1", "200", "OK"

        base.send :http_request, ANY_VALID_URL
        base.success?.should be_true
      end
    end
  end
end
