module BetcheckHelper


  def get_place_html_id(place)
    place_id_hash = {
      "京都" => "#kyoto",
      "東京" => "#tokyo",
      "中山" => "#nakayama",
      "小倉" => "#ogura"
    }
    place_id_hash.fetch(place)
  end
end
