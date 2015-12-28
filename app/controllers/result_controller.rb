# FIXME: 本来ここから読むべきではないはず
require_relative '../util/numeric.rb'
class ResultController < ApplicationController
  def result
    # postされてきた値を取得
    # year = params[:result][:year].to_i
    # place = params[:result][:place]
    # popularity = params[:result][:popularity].to_i
    # border_start = params[:result][:border_start].to_f
    # border_end = params[:result][:border_end]
    # 結果を格納
    @results = calc_results(2015, "札幌", 1, 1.0, 3.5)
  end

  def calc_results(year, place, popularity, border_start, border_end)
    results_hash = {}
    #results_array << calc_result(2015, "札幌", 1, 0)
    border = border_start
    while border <= border_end do
      result = calc_result(2015, "札幌", 1, border)
      results_hash[border] = result
      border = (border+0.1).rounddown(1)
    end
    results_hash
  end

  def calc_result(year, place, popularity, border)
    # UGLYHACK: 本来的には一つのSQLでできるはず
    result = 0
    horce_results = []

    # TODO: 年で絞る
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
    result
  end
end
