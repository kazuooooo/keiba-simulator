# FIXME: 本来ここから読むべきではないはず
require_relative '../util/numeric.rb'
class ResultController < ApplicationController
  def result
    # postされてきた値を取得
    @year = params[:result][:year].to_i
    @place = params[:result][:place]
    @popularity = params[:result][:popularity].to_i
    @border_start = params[:result][:border_start].to_f
    @border_end = params[:result][:border_end].to_f

    # 計算結果を格納
    results = calc_results(@year, @place, @popularity, @border_start, @border_end)
    # 結果をグラフに描画
    draw_graph(results)
  end

  # border_startからborder_endまで0.1刻みで計算
  def calc_results(year, place, popularity, border_start, border_end)
    results_hash = {}
    border = border_start
    while border <= border_end do
      result = calc_result(year, place, popularity, border)
      results_hash[border.rounddown(1)] = result
      border = border + 0.1
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
      race.horceresults.each do |horce_result|
        # HorceResultからpolularityで絞って取得
        horce_results << horce_result if (horce_result.popularity == popularity)
      end
    end
    # 各HorceResultに対して
    horce_results.each do |horce_result|
      ## オッズがborderより上じゃない場合は買わないので飛ばす
      if horce_result.odds > border
        ### 馬券を買うので100円引く
        result -= 100
        ### 着順が1位の場合オッズ✖︎100円を合計にたす
        result += 100 * horce_result.odds if horce_result.ranking == 1
      end
    end
    result
  end

  def draw_graph(results)
    border_array = []
    result_array = []

    results.each do |result|
      border_array << result[0]
      result_array << result[1]
    end

    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "#{@year}年 #{@place}競馬場
                     #{@popularity}番人気
                     ボーダーオッズ#{@border_start}〜#{@border_end}"
              )
      f.xAxis(categories: border_array)
      f.series(name: '結果(円)', data: result_array)
    end
  end
end
