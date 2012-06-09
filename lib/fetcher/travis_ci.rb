module Fetcher
  class TravisCI < Base
    format :json
    base_uri "travis-ci.org"

    add_fetcher_filters lambda{ |builds| builds.max_by{|b| b[:started_at]} }

    def uri
      "/#{@cue.owner}/#{@cue.name}/builds.json"
    end
  end
end
