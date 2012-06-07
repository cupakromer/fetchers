require 'json'

module Fetcher
  module TestData
    class Vimeo
      JSON_DATA = File.read("#{File.dirname __FILE__}/vimeo.json").freeze

      EXPECTED_DATA = {
        title:        "Video 2",
        url:          "http://www.vimeo.com/2",
        description:  "Yummy stuff",
        date:         "2012-04-06 5:27:38",
        user:         "John Smith",
        number_likes: "8",
        number_plays: "10",
        duration:     "222",
        tags:         "Cake, Pie, Food"
      }.freeze
    end
  end
end
