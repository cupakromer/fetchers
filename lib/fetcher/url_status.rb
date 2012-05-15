module Fetcher
  class UrlStatus < Base
    def fetch
      @data = begin
        http_request @cue, timeout: 30
        { available: success? }
      rescue => e
        { available: false }
      end
    end
  end
end
