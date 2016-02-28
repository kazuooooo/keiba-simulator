class BetconditionsController < ApplicationController
  include Caliculator, GraphDrawer
  PopularityCondition = Struct.new(:popularity, :border_start, :border_end)
  before_action :set_mode
  before_action :set_places, only: [:new, :update]
  before_action :analyze_build_pop_cons, only: [:analyze_result]

  def new
    @bet_condition = Betcondition.new
  end

  def create
    if user_signed_in?
      @betcondition = current_user.betconditions.build(betcondition_params)
    else
      @betcondition = Betcondition.new(betcondition_params)
    end
    if params[:mode] == "try"
      respond_to do |format|
        if @betcondition.save
          format.html { redirect_to try_result_betcondition_path(@betcondition), notice: '計算が完了しました。' }
        else
          format.html { redirect_to new_betcondition_path(:mode => "try"), notice: @betcondition.errors.full_messages }
        end
      end
    elsif params[:mode] == "analyze"
      respond_to do |format|
        if @betcondition.save
          format.html { redirect_to analyze_result_betcondition_path(@betcondition), notice: '計算が完了しました。' }
        else
          format.html { redirect_to new_betcondition_path(:mode => "analyze"), notice: @betcondition.errors.full_messages }
        end
      end
    end

  end

  def update
  end

  def destroy
  end

  def try_result
    bet_condition = Betcondition.find(params[:id])
    # result 各popconditionの合計値
    # {popcon1 => result_hash1, popcon2 => result_hash2....}
    try_result_hash = calc_try(bet_condition)
    # slack飛ばしてみる
    # Slack.chat_postMessage(text: "helloooooooooo", username: "Opinion Notifier", channel: "#keibabotmain")
    # 値が入ってこなかった場合は計算しない(順番がずれないように注意)

    # 結果をグラフに描画
    draw_try_graph(try_result_hash)
    @table_data = try_result_hash
  end

  def analyze_result
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
    # save result_hash
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def betcondition_params
    params.require(:betcondition).permit(:name,
                                         :place_id,
                                         :start_date,
                                         :end_date,
                                         :mode,
                                         :popconditions_attributes => [:id,
                                                                       :popularity,
                                                                       :betcondition_id,
                                                                       :odds_start,
                                                                       :odds_end,
                                                                       :_destroy,
                                                                       ]
                                        )
  end

  private
  def analyze_build_pop_cons
    bet_condition = Betcondition.find(params[:id])
    @date_from = bet_condition.start_date
    @date_to   = bet_condition.end_date
    @place     = bet_condition.place.name

    # 人気順をあるだけ取得
    @pops_cons = []
    bet_condition.popconditions.each do |pop_con|
      @pops_cons << PopularityCondition.new(
                      pop_con.popularity,
                      pop_con.odds_start,
                      pop_con.odds_end
                    )
    end
  end

  def set_places
    @places = Place.all
  end

  def set_mode
    @mode = params[:mode]
  end


end
