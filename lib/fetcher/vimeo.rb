require 'json'

module Fetcher
  class Vimeo < Base
    BASE_URL = "http://vimeo.com/api/v2/channel/"

    def fetch
      videos = http_request("#{BASE_URL}#{@cue}/videos.json") do |json_data|
        JSON.parse json_data, allow_nan: true, symbolize_names: true
      end

      most_recent = videos.max_by{|v| v[:upload_date]}

      {
        title: most_recent[:title],
        url: most_recent[:url],
        description: most_recent[:description],
        date: most_recent[:upload_date],
        user: most_recent[:user_name],
        number_likes: most_recent[:stats_number_of_likes],
        number_plays: most_recent[:stats_number_of_plays],
        duration: most_recent[:duration],
        tags: most_recent[:tags]
      }
    end
  end
end
