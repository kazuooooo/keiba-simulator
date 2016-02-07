class TryController < ApplicationController
  include Caliculator, GraphDrawer
  before_action :set_betcondition, only: [:result]
  before_action :set_places, only: [:new]
  PopularityCondition = Struct.new(:popularity, :border_start, :border_end)
  def new
    @bet_condition = Betcondition.new
  end

  def result
    # result 各popconditionの合計値
    # {popcon1 => result_hash1, popcon2 => result_hash2....}
    try_result_hash = calc_try(@betcondition)
    # slack飛ばしてみる
    # Slack.chat_postMessage(text: "helloooooooooo", username: "Opinion Notifier", channel: "#keibabotmain")
    # 値が入ってこなかった場合は計算しない(順番がずれないように注意)

    # 結果をグラフに描画
    draw_try_graph(try_result_hash)
    @table_data = try_result_hash
  end

  def set_betcondition
    @betcondition = Betcondition.last
  end

  def set_places
    @places = Place.all
  end

end
