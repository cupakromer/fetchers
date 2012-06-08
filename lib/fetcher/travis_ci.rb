module Fetcher
  class TravisCI < Base
    format :json
    base_uri "travis-ci.org"

    def uri
      "/#{@cue.owner}/#{@cue.name}/builds.json"
    end

    def process_response( builds )
      builds.max_by{|b| b[:started_at]}
    end
  end
end
