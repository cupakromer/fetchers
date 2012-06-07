require 'json'

module Fetcher
  class Vimeo < Base
    base_uri "vimeo.com/api/v2/channel"
    format :json

    fetcher do |videos|
      videos.max_by{|v| v["upload_date"]}
    end

    def uri
      "/#{@cue}/videos.json"
    end

    def after_fetch(most_recent)
      generate_data_hash(most_recent)
    end

    private
    def generate_data_hash(video)
      @data = {
        title:        video["title"],
        url:          video["url"],
        description:  video["description"],
        date:         video["upload_date"],
        user:         video["user_name"],
        number_likes: video["stats_number_of_likes"],
        number_plays: video["stats_number_of_plays"],
        duration:     video["duration"],
        tags:         video["tags"]
      }
    end
  end
end
