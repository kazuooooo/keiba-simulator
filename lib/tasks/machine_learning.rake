require 'csv'
require 'date'

class Row < Struct.new(:race,
                       :sort_by_odds,
                       :sort_by_ranking,
                       :course,
                       :course_condition,
                       :rotation,
                       :weather,
  :distance,
  )
end

namespace :machine_learning do
  desc "create machine learning data"
  task :create => :environment do |task, args|
    # rowデータ作成
    @rows = create_row_data
    # csv吐き出し
    output_csv_data(@rows)
  end
end

def create_row_data
  @rows = []
  # 16頭立てのレースのみ
  Race.horces_count(16).each do |race|
    # 欠場馬が出ているパターンは除く
    next if race.horceresults.any? { |result| result.odds == 0.0 }
    @row                  = Row.new()
    @row.race             = Race.find(race)
    @row.distance         = @row.race.distance
    @row.course           = Race.convert_string_to_numeral_value(:course, @row.race.course)
    @row.rotation         = Race.convert_string_to_numeral_value(:rotation, @row.race.rotation)
    @row.course_condition = Race.convert_string_to_numeral_value(:course_condition, @row.race.course_condition)
    @row.weather          = Race.convert_string_to_numeral_value(:weather, @row.race.weather)
    @row.sort_by_odds     = race.sort_by_horce_result(:odds)
    @row.sort_by_ranking  = race.sort_by_horce_result(:ranking)
    @rows.push(@row)
  end
  @rows
end

def output_csv_data(rows)
  CSV.open("machine_learning_data", "a") do |csv|
    rows.each do |row|
      csv << [
          row.race.id, #race_id(for_debug)
          row.race.race_num, #race_num(fordebug)
          # race_info
          row.distance,
          row.course,
          row.course_condition,
          row.rotation,
          row.weather,
          # odds
          row.sort_by_odds[0].odds,
          row.sort_by_odds[1].odds,
          row.sort_by_odds[2].odds,
          row.sort_by_odds[3].odds,
          row.sort_by_odds[4].odds,
          row.sort_by_odds[5].odds,
          row.sort_by_odds[6].odds,
          row.sort_by_odds[7].odds,
          row.sort_by_odds[8].odds,
          row.sort_by_odds[9].odds,
          row.sort_by_odds[10].odds,
          row.sort_by_odds[11].odds,
          row.sort_by_odds[12].odds,
          row.sort_by_odds[13].odds,
          row.sort_by_odds[14].odds,
          row.sort_by_odds[15].odds,
          # win_horce_popularity
          # 出てない馬が人気順0番になってしまっているので修正が必要
          row.sort_by_ranking.first.popularity,
      ]
    end
  end
end