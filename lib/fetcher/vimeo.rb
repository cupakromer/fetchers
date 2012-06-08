require 'json'

module Fetcher
  class Vimeo < Base
    format :json
    base_uri "vimeo.com/api/v2/channel"

    MostRecentVideo = lambda{ |videos| videos.max_by{ |v| v[:upload_date] } }

    def uri
      "/#{@cue}/videos.json"
    end

    def process_response( videos )
      @video = MostRecentVideo.call videos
      generate_hash
    end

    private
    def generate_hash
      {
        title:        @video[:title],
        url:          @video[:url],
        description:  @video[:description],
        date:         @video[:upload_date],
        user:         @video[:user_name],
        number_likes: @video[:stats_number_of_likes],
        number_plays: @video[:stats_number_of_plays],
        duration:     @video[:duration],
        tags:         @video[:tags]
      }
    end
  end
end
