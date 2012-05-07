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
      ].each do |url, uri_request|
        it "should make an HTTP request to the provided URL" do
          # TODO: Learn to fake the internet itself
          # This is a very brittle test

          Net::HTTP.should_receive(:get_response).with(URI url)

          b = Base.new EMPTY_CUE
          b.send :http_request, url
        end
      end
    end
  end
end
