module GraphDrawer
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

  def draw_try_graph(try_results_hash)
    xAxis_categories = []
    money_data       = []
    win_count_data   = []
    race_count_data  = []
    money_data_total = 0
    win_count_total  = 0
    race_count_total = 0

    try_results_hash.each do |con, result|
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
