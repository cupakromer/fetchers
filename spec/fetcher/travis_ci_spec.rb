require 'spec_helper'
require 'ostruct'
require_relative 'test_data/travis_ci'

module Fetcher
  describe TravisCI do
    describe "#fetch" do
      before( :each ) do
        url = "http://travis-ci.org/owner_name/name/builds.json"

        stub_request(:get, url).to_return(body: TestData::TravisCI::JSON_DATA)
      end

      let( :travis_ci_project ) {
        TravisCI.new OpenStruct.new owner: "owner_name", name: "name"
      }

      it "returns data about the most recent build" do
        travis_ci_project.fetch.should == TestData::TravisCI::EXPECTED_DATA
      end

      it "sets the data about the most recent build to reader :data" do
        travis_ci_project.fetch
        travis_ci_project.data.should == TestData::TravisCI::EXPECTED_DATA
      end

    end
  end
end
