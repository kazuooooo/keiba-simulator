# いろんなところで使う汎用メソッド
module Util
  def extract_place(place_string)
    places = Place.all.map do |place|
               place.name
             end
    place_string.match(/#{places.join("|")}/).to_s
  end
  module_function :extract_place
end
