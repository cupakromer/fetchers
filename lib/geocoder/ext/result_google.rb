require 'geocoder/results/google'

class Geocoder::Result::Google
  BOUNDING_BOX_KEYS = [:north_lat, :east_lng, :south_lat, :west_lng].freeze

  def bounding_box( order = BOUNDING_BOX_KEYS )
    coordinates = map_box_keys_to_values
    order.map{ |key| coordinates[key] }
  end

  private

  def extract_bounding_box
    bounds = geometry["bounds"]
    [
      bounds["northeast"]["lat"], # :north_lat
      bounds["northeast"]["lng"], # :east_lng
      bounds["southwest"]["lat"], # :south_lat
      bounds["southwest"]["lng"], # :west_lng
    ]
  end

  # Map the BOUNDING_BOX_KEYS to the associated values
  # Returns hash as:
  # {
  #   north_lat: 39.0464399, east_lng: -76.9836289,
  #   south_lat: 38.995162,  west_lng: -77.033157
  # }
  def map_box_keys_to_values
    Hash[*BOUNDING_BOX_KEYS.zip(extract_bounding_box).flatten]
  end
end
