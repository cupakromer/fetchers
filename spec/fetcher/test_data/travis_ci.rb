require 'json'

module Fetcher
  module TestData
    class TravisCI
      JSON_DATA = File.read("#{File.dirname __FILE__}/travis_ci.json").freeze

      EXPECTED_DATA = {
        id:            1385043,
        repository_id: 14871,
        number:        "29",
        state:         "finished",
        result:        1,
        started_at:    "2012-05-21T01:03:35Z",
        finished_at:   "2012-05-21T01:07:11Z",
        duration:      1594,
        commit:        "4fd45c07f559293ab44b069ea82cf9f058e086e9",
        branch:        "2.2",
        message:       "Merge pull request #660 from jellehenkens/2.2-http-socket-duplicate-code\n\nRemoving an unnecessary if statement in HttpSocket",
        event_type:    "push"
      }.freeze
    end
  end
end
