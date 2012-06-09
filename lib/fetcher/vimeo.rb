require 'json'

module Fetcher
  class Vimeo < Base
    format :json
    base_uri "vimeo.com/api/v2/channel"

    MostRecentVideo = ->(videos){ videos.max_by{ |v| v[:upload_date] } }

    add_fetcher_options after: :generate_hash
    add_fetcher_filters MostRecentVideo

    def uri
      "/#{@cue}/videos.json"
    end

    private
    def generate_hash
      {
        title:        @data[:title],
        url:          @data[:url],
        description:  @data[:description],
        date:         @data[:upload_date],
        user:         @data[:user_name],
        number_likes: @data[:stats_number_of_likes],
        number_plays: @data[:stats_number_of_plays],
        duration:     @data[:duration],
        tags:         @data[:tags]
      }
    end
  end
end
