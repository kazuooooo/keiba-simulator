# FIXME: 本来ここから読むべきではないはず
require_relative '../util/numeric.rb'
class ResultController < ApplicationController
  def result
    # postされてきた値を取得(さすがにconditionのstructでまとめた方が良いと思う)
    @date_from = Date.new(
      params['result']['date_from(1i)'].to_i,
      params['result']['date_from(2i)'].to_i,
      params['result']['date_from(3i)'].to_i
      )
    @date_to = Date.new(
      params['result']['date_to(1i)'].to_i,
      params['result']['date_to(2i)'].to_i,
      params['result']['date_to(3i)'].to_i
      )
    @place = params[:result][:place]
    @popularity = params[:result][:popularity].to_i
    @border_start = params[:result][:border_start].to_f
    @border_end = params[:result][:border_end].to_f
    # 計算結果を格納
    results = calc_results(@date_from, @date_to, @place, @popularity, @border_start, @border_end)
    # 結果をグラフに描画
    draw_graph(results)
  end

  # border_startからborder_endまで0.1刻みで計算
  def calc_results(date_from, date_to, place, popularity, border_start, border_end)
    results_hash = {}
    border = border_start
    while border <= border_end do
      result = calc_result(date_from, date_to, place, popularity, border)
      results_hash[border.rounddown(1)] = result
      border = border + 0.1
    end
    results_hash
  end

  def calc_result(date_from, date_to, place, popularity, border)
    ### get target horceresult ※ テスト駆動
    horce_results = get_target_horce_result(date_from, date_to, place, popularity)
    ###

    ### simulate races
    result = 0
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
    ###
    result
  end

  # 検索条件に合うhorce_resultを取得
  def get_target_horce_result(date_from, date_to, place, popularity)
    races = Race.where(date: date_from..date_to, place_id:Place.find_by(name: place))
    horceresults = races.map do |race|
                     race.horceresults.where(popularity: popularity)
                   end
    horceresults.flatten
  end

  # グラフを描画
  def draw_graph(results)
    border_array = []
    result_array = []

    results.each do |result|
      border_array << result[0]
      result_array << result[1]
    end

    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "#{@date_from} - #{@date_to} #{@place}競馬場
                     #{@popularity}番人気
                     ボーダーオッズ#{@border_start}〜#{@border_end}"
              )
      f.xAxis(categories: border_array)
      f.series(name: '結果(円)', data: result_array)
    end
  end
end
