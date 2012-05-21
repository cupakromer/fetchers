module Fetcher
  class TravisCI < Base
    base_uri "travis-ci.org"
    format :json

    def fetch
      @data = http_request("/#{@cue.owner}/#{@cue.name}/builds.json") do |builds|
        most_recent_build = builds.max_by{|b| b["started_at"]}
      end
    end
  end
end
