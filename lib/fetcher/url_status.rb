module Fetcher
  class UrlStatus < Base
    def fetch
      @data = begin
        http_request @cue
        { available: success? }
      rescue => e
        { available: false }
      end
    end
  end
end
