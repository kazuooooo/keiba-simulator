# FIXME: 本来ここから読むべきではないはず
require_relative '../util/numeric.rb'
# require_relative '../util/bet_check_scraper'
class ResultController < ApplicationController
  PopularityCondition = Struct.new(:popularity, :border_start, :border_end)
  # WinRaceInfo = Struct.new(:race, :horce_result)
  def analyze_result
    # postされてきた値をセット
    set_post_value('analyze_result')
    # 各人気順を計算
    pops_calc_results = @pops_cons.map do |pop_con|
                          Caliculator.calc_range(@date_from,
                                                 @date_to,
                                                 @place,
                                                 pop_con.popularity,
                                                 pop_con.border_start,
                                                 pop_con.border_end)
                        end
    # pop_conをkey, pop_resultをvalueにしたハッシュ
    con_results_hash = Hash[@pops_cons.zip(pops_calc_results)]
    # 結果をグラフに描画
    draw_analyze_graph(con_results_hash)
  end

  def try_result
    # slack飛ばしてみる
    # Slack.chat_postMessage(text: "helloooooooooo", username: "Opinion Notifier", channel: "#keibabotmain")
    set_post_value('try_result')
    # 値が入ってこなかった場合は計算しない(順番がずれないように注意)
    pops_calc_results = @pops_cons.map do |pop_con|
                          horce_results = get_target_horce_results(@date_from,
                                                                   @date_to,
                                                                   @place,
                                                                   pop_con.popularity)
                          calc(horce_results, pop_con.border_start)
                        end
    con_results_hash = Hash[@pops_cons.zip(pops_calc_results)]
    # 結果をグラフに描画
    draw_try_graph(con_results_hash)
    @table_data = pops_calc_results
    @table_data.each do |pops_calc_result|
      pops_calc_result[:win_races].each do |win_race|
        puts win_race.race.date
        puts win_race.race.race_num
        puts win_race.horce_result.popularity
        puts win_race.horce_result.odds
      end
    end
  end

  def set_post_value(action)
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
                       num.to_s,
                       params[action]['border_start' << num.to_s].to_f,
                       params[action]['border_end' << num.to_s].to_f
                     )
      end
    end
    # 未入力のものは削除
    @pops_cons.reject!{|p| p.border_start == 0.0 && p.border_end == 0.0}
  end

  def draw_analyze_graph(con_results_hash)
    @graphs = []
    con_results_hash.each do |con, results|
      x_axis_vals = []
      y_result_vals = []
      results.each do |odds, odds_result|
        x_axis_vals << odds
        y_result_vals << odds_result.fetch(:money)
      end

      @graphs << LazyHighCharts::HighChart.new('graph') do |f|
        f.title(text: "#{@date_from} - #{@date_to} #{@place}競馬場
                       #{con.popularity}番人気
                       ボーダーオッズ#{con.border_start}〜#{con.border_end}")
        f.xAxis(categories: x_axis_vals)
        f.series(name: '結果(円)', data: y_result_vals)
      end
    end
  end

  def draw_try_graph(con_results_hash)
    xAxis_categories = []
    money_data       = []
    win_count_data   = []
    race_count_data  = []
    money_data_total = 0
    win_count_total  = 0
    race_count_total = 0

    con_results_hash.each do |con, result|
      xAxis_categories << con.popularity
      money_data       << result[:money]
      win_count_data   << result[:win_race_count]
      race_count_data  << (result[:win_race_count] + result[:lose_race_count])
      money_data_total += result[:money]
      win_count_total  += result[:win_race_count]
      race_count_total += (result[:win_race_count] + result[:lose_race_count])
    end

    xAxis_categories << 'total'
    money_data       << money_data_total
    win_count_data   << win_count_total
    race_count_data  << race_count_total

    @graph_data = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: '結果')
      f.xAxis(categories: xAxis_categories)
      f.options[:yAxis] = [{ title: { text: '円' }}, { title: { text: 'レース数'}, opposite: true}]
      f.series(name: 'お金', data: money_data, type: 'column', yAxis: 0)
      f.series(name: '勝利レース数', data: win_count_data, type: 'column', yAxis: 1)
      f.series(name: '合計レース数', data: race_count_data, type: 'column', yAxis: 1)
    end
  end

end
