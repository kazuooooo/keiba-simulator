# FIXME: 本来ここから読むべきではないはず
require_relative '../util/numeric.rb'
class ResultController < ApplicationController
  PopularityCondition = Struct.new(:popularity, :border_start, :border_end)
  def result
    # postされてきた値をセット
    set_post_value('result')
    # 各人気順を計算
    pops_calc_results = @pops_cons.map do |pop_con|
                          calc_results(@date_from,
                                       @date_to,
                                       @place,
                                       pop_con.popularity,
                                       pop_con.border_start,
                                       pop_con.border_end)
                        end
    # pop_conをkey, pop_resultをvalueにしたハッシュ
    con_results_hash = Hash[@pops_cons.zip(pops_calc_results)]
    # 結果をグラフに描画
    draw_graphs(con_results_hash)
  end

  def try_result
    set_post_value('try_result')
    binding.pry
    # 値が入ってこなかった場合は計算しない(順番がずれないように注意)
    pops_calc_results = @pops_cons.map do |pop_con|
                          horce_results = get_target_horce_results(@date_from,
                                                                   @date_to,
                                                                   @place,
                                                                   pop_con.popularity)
                          simulate_races(horce_results, pop_con.border_start)
                        end
    binding.pry
  end

  def set_post_value(action)
    # postされてきた値を取得(さすがにconditionのstructでまとめた方が良いと思う)
    @date_from = Date.new(
      params[action]['date_from(1i)'].to_i,
      params[action]['date_from(2i)'].to_i,
      params[action]['date_from(3i)'].to_i
      )
    @date_to = Date.new(
      params[action]['date_to(1i)'].to_i,
      params[action]['date_to(2i)'].to_i,
      params[action]['date_to(3i)'].to_i
      )
    @place = params[action][:place]
    @border_down = params[action][:border_down]

    # 人気順をあるだけ取得
    @pops_cons = []
    for num in 1..18 do
      unless params[action]['border_start' << num.to_s].nil? then
        @pops_cons << PopularityCondition.new(
                      # 範囲計算の方要修正
                      num.to_s,
                      params[action]['border_start' << num.to_s].to_f,
                      params[action]['border_end' << num.to_s].to_f
                     )
      end
    end
  end

  # 単体で計算できるように分けたほうがいい
  def calc_results(date_from, date_to, place, popularity, border_start, border_end)
    horce_results = get_target_horce_results(date_from, date_to, place, popularity)
    results_hash = {}
    interval_val = (border_end - border_start) / 10
    border = border_start
    while border <= border_end do
      result = simulate_races(horce_results, border)
      results_hash[border.rounddown(1)] = result
      border = border + interval_val
    end
    results_hash
  end

  # 検索条件に合うhorce_resultを取得
  def get_target_horce_results(date_from, date_to, place, popularity)
    # まだまとめれる これでもまだ多分SQLが大量発行される
    # horceresults = Horceresults.where(popularity: popularity).map do |horce_result|
    #                   horce_result.race.where(date: date_from..date_to, place_id:Place.find_by(name: place))
    #                end
    races = Race.where(date: date_from..date_to, place_id:Place.find_by(name: place))
    horceresults = races.map do |race|
                     race.horceresults.where(popularity: popularity)
                   end
    horceresults.flatten
  end

  # シミュレートして結果を返す
  def simulate_races(horce_results, border)
    result = 0
    # 各HorceResultに対して
    horce_results.each do |horce_result|
      ## オッズがborderより上じゃない場合は買わないので飛ばす
      # if horce_result.odds > border
      if border_judge(horce_result.odds, border)
        ### 馬券を買うので100円引く
        result -= 100
        ### 着順が1位の場合オッズ✖︎100円を合計にたす
        result += 100 * horce_result.odds if horce_result.ranking == 1
      end
    end
    result
  end

  def border_judge(odds, border)
    if @border_down.to_i.zero?
      odds >= border
    else
      odds <= border
    end
  end

  # グラフを描画
  def draw_graphs(con_results_hash)
    @graphs = []
    con_results_hash.each do |con, results|
      border_array = []
      result_array = []
      results.each do |result|
        border_array << result[0]
        result_array << result[1]
      end

      @graphs << LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "#{@date_from} - #{@date_to} #{@place}競馬場
                       #{con.popularity}番人気
                       ボーダーオッズ#{con.border_start}〜#{con.border_end}")
        f.xAxis(categories: border_array)
        f.series(name: '結果(円)', data: result_array)
      end
    end
  end
end
