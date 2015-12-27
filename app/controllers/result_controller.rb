class ResultController < ApplicationController
  def result
    # year = params[:result][:year]
    # place = params[:result][:place]
    # popularity = params[:result][:popularity]
    # border = params[:border][:border]
    result = calc_result(2011,"札幌",1,3)
  end

  def calc_result(year, place, popularity, border)
    # UGLYHACK: 本来的には一つのSQLでできるはず
    result = 0
    horce_results = []

    # yearとplaceで絞ってHorceRaceResultを取得(yearは保留)
    place_id = Place.find_by(:name => place)
    races = Race.where('place_id = ?', place_id)

    races.each do |race|
      race.horceresults.each do |result|
        # HorceResultからpolularityで絞って取得
        horce_results << result if (result.popularity == popularity)
      end
    end

    # 各HorceResultに対して
    horce_results.each do |horce_result|
      ## オッズがborderより上じゃない場合は買わないので飛ばす
      if horce_result.odds > border
        ### 馬券を買うので100円引く
        result -= 100
        ### 着順が1位の場合オッズ✖︎100円を合計にたす
        result += 100*horce_result.odds if horce_result.ranking == 1
      end
    end
    puts "result"<<result.to_s
  end
end
