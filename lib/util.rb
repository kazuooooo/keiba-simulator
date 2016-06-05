# いろんなところで使う汎用メソッド
module Util
  def extract_place(place_string)
    places = Place.all.map do |place|
               place.name
             end
    place_string.match(/#{places.join("|")}/).to_s
  end

  def extract_date(text)
    text.slice(/....年.?月.?日/)
  end

  def frame_num_from_horce_num(horce_num)
    divide = horce_num / 2
    add = horce_num % 2
    divide + add
  end
  module_function :extract_place, :extract_date, :frame_num_from_horce_num
end
