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
  task :create, ['date_from', 'date_to', 'players'] => :environment do |task, args|
    args.with_defaults(players: 16)
    # rowデータ作成
    @rows = create_row_data(date_from: args[:date_from], date_to: args[:date_to], players: args[:players])
    # csv吐き出し
    output_csv_data(@rows)
  end

  desc "get todays race data from JRA web site"
  task :output_today_data, ['month', 'date'] => :environment do |task, args|
    scraped_data = DataScraper.scrape_machine_learning_data(args[:month].to_i, args[:date].to_i)
    row_data = create_row_data_for_webscrape(scraped_data)
    output_csv_data(row_data)
  end
end

def create_row_data(date_from: nil, date_to: nil, players: nil)
  date_to = date_from if date_to.blank?
  @rows = []
  races = Race.horces_count(players)
  races = races.sort_by_date(date_from.to_date, date_to.to_date) if date_from.present?
  races.each do |race|
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

def create_row_data_for_webscrape(scraped_data)
  rows = []
  scraped_data.each do |place, races|
    races.each do |race|
      next if race.horce_objs.size < 16 #16頭以上立てのみ
      row = Row.new()
      row.race = race
      row.distance = race.distance.match(/\d{4}/).to_s
      row.course = Race.convert_string_to_numeral_value(:course, race.course)
      row.rotation = Race.convert_string_to_numeral_value(:rotation, race.rotation)
      row.course_condition = 0 # notget
      row.weather = 0
      row.sort_by_odds = race.horce_objs.sort_by{|horce| horce.odds}
      rows.push(row)
    end
  end
  rows
end

def output_csv_data(rows)
  CSV.open("machine_learning_data#{Time.now.strftime("%Y%m%-d-%I:%M")}", "a") do |csv|
    rows.each do |row|
        csv << [
          row.race.try(:id) || Place.find_by(name: row.race.title.match(/回../).to_s.delete("回)")).id,
          row.race.race_num,
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
          row.distance,
          row.course,
          row.course_condition,
          row.rotation,
          row.weather,
          #horce num
          row.sort_by_odds[0].horce_num,
          row.sort_by_odds[1].horce_num,
          row.sort_by_odds[2].horce_num,
          row.sort_by_odds[3].horce_num,
          row.sort_by_odds[4].horce_num,
          row.sort_by_odds[5].horce_num,
          row.sort_by_odds[6].horce_num,
          row.sort_by_odds[7].horce_num,
          row.sort_by_odds[8].horce_num,
          row.sort_by_odds[9].horce_num,
          row.sort_by_odds[10].horce_num,
          row.sort_by_odds[11].horce_num,
          row.sort_by_odds[12].horce_num,
          row.sort_by_odds[13].horce_num,
          row.sort_by_odds[14].horce_num,
          row.sort_by_odds[15].horce_num,
          # win_horce_popularity
          # 出てない馬が人気順0番になってしまっているので修正が必要
          row.try(:sort_by_ranking) || 0,
      ]
    end
  end
end