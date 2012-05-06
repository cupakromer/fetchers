require 'spec_helper'

module Fetcher
  describe Base do
    describe "#success?" do
      it "returns the status of the last http request" do
        b = Base.new []

        b.should_receive(:last_request_status)

        b.success?
      end
    end

    describe "#fetch" do
      it "raises a must be implemented by child class error" do
        b = Base.new []

        expect { b.fetch }.to raise_error "Must be implemented by child class"
      end
    end
  end
end
