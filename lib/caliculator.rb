module Caliculator
  WinRaceInfo = Struct.new(:race, :horce_result)

  def calc_try(betcondition)
    # 各popconについてresultを計算
    try_results_hash = {}
    betcondition.popconditions.each do |popcon|
      try_results_hash[popcon] = calc_sum(betcondition.start_date, betcondition.end_date, betcondition.place, popcon)
    end
    try_results_hash
  end

  def calc_range(date_from, date_to, place, popularity, odds_start, odds_end)
    horce_results = get_target_horce_results(date_from, date_to, place, popularity)
    results_hash = {}
    odds = odds_start
    while odds <= odds_end do
      target_horce_results = horce_results.select{|result| result.odds == odds.round(1)}
      results_hash[odds.round(1)] = calc(target_horce_results)
      odds += 0.1
    end
    results_hash
  end

  def calc_sum(date_from, date_to, place, popcon)
    horce_results = get_target_horce_results_v2(date_from, date_to, place, popcon)
    calc_results  = calc(horce_results)
  end

  # 検索条件に合うhorce_resultを取得
  def get_target_horce_results(date_from, date_to, place, popularity)
    result = Horceresult.includes(:race).where(horceresults: {popularity: popularity},
                                            races: {date: date_from..date_to,
                                                    place_id: Place.find_by(name: place)})
  end
  # 条件に合う
  def get_target_horce_results_v2(date_from, date_to, place, popcon)
    result = Horceresult.includes(:race).where(horceresults: {popularity: popcon.popularity,
                                                           odds: (popcon.odds_start)..(popcon.odds_end)},
                                            races: {date: date_from..date_to})
  end

  # 計算して結果を返す
  def calc(horce_results)
    money = 0
    win_races = []
    race_count = 0
    # 各HorceResultに対して
    horce_results.each do |horce_result|
      money -= 100
      race_count += 1
      ### 着順が1位の場合オッズ✖︎100円を合計にたす
      if horce_result.ranking == 1
        money += 100 * horce_result.odds
        win_races << WinRaceInfo.new(
                       horce_result.race,
                       horce_result
                     )
      end
    end

    lose_race_count = race_count - win_races.size
    return {
      :money           => money,
      :win_races       => win_races,
      :win_race_count  => win_races.size,
      :lose_race_count => lose_race_count,
      :race_count      => win_races.size + lose_race_count,
    }
  end
end
