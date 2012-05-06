module Fetcher
  class Base
    def initialize cue
    end

    def success?
      !!last_request_status
    end

    def fetch
      fail "Must be implemented by child class"
    end

    private

    def last_request_status
    end
  end
end
