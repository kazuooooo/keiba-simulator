require 'csv'
require 'date'

class Row < Struct.new(:race, :sort_by_odds, :sort_by_ranking); end

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
  Race.horces_count(16) .each do |race|
    @row = Row.new()
    @row.race = Race.find(race)
    @row.sort_by_odds = race.sort_by_horce_result(:odds)
    @row.sort_by_ranking = race.sort_by_horce_result(:ranking)
    @rows.push(@row)
  end
  @rows
end

def output_csv_data(rows)
  CSV.open("machine_learning_data","a") do |csv|
    rows.each do |row|
      csv << [
          row.race.id,
          row.race.date.to_s, #date
          row.race.race_num,  #race_num
          # ods
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
          row.sort_by_ranking.first.popularity,
      ]
    end
  end
end