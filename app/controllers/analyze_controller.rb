class AnalyzeController < ApplicationController
  include GraphDrawer, Caliculator
  PopularityCondition = Struct.new(:popularity, :border_start, :border_end)
  before_action :set_post_values, only: [:result]

  def index
  end

  def result
    # 各人気順を計算
    pops_calc_results = @pops_cons.map do |pop_con|
                          calc_range(@date_from,
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


  def set_post_values
    @date_from = Date.parse(params["result"]["date_from"])
    @date_to   = Date.parse(params["result"]["date_to"])
    @place     = params["result"][:place]

    # 人気順をあるだけ取得
    @pops_cons = []
    for num in 1..18 do
      unless params["result"]['border_start' << num.to_s].nil? then
        @pops_cons << PopularityCondition.new(
                       num.to_s,
                       params["result"]['border_start' << num.to_s].to_f,
                       params["result"]['border_end' << num.to_s].to_f
                     )
      end
    end
    # 未入力のものは削除
    @pops_cons.reject!{|p| p.border_start == 0.0 && p.border_end == 0.0}
  end
end
