require 'csv'
require 'date'
class DataMaker
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


  def self.create_row_data(date_from: nil, date_to: nil, players: nil)
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

  def self.create_row_data_for_webscrape(scraped_data)
    rows = []
    scraped_data.each do |place, races|
      races.each do |race|
        next if race.horce_objs.size != 16 #16頭立てのみ
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

  def self.output_csv_data(rows)
    CSV.open("#{Rails.root}/predict_python/machine_learning_data#{Time.now.strftime("%Y%m%-d-%I:%M")}", "a") do |csv|
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



  # scraping してきたRace, HorceデータをDBに保存する
  def self.create_raceobjs(rows)
    ## tableオブジェクトに変換してtableデータを作成
    rows.each do |row|
      ### Placeを使ってRaceをビルド
      place = Place.find_by(:name => Util.extract_place(row[:race].title))
      ### 日付をDateオブジェクトに変換
      date_str = Util.extract_date(row[:race].title)
      date_obj = Date.strptime(date_str,"%Y年 %m月 %d日")
      ### すでに作られていなければraceモデルを作成
      unless (race = Race.find_by(date: date_obj, place_id: place.id, race_num: row[:race].race_num)).present?
        race = place.races.build(date: date_obj,
                                 race_num: row[:race].race_num,
                                 race_name: row[:race].race_name,
                                 course: row[:race].course,
                                 rotation: row[:race].rotation,
                                 distance: row[:race].distance,
                                 weather: nil,
                                 course_condition: nil
        )
        place.save
      end

      sorted_horce_objs = row[:race].horce_objs.sort_by{ |h| h.odds }
      sorted_horce_objs.each.with_index(1) do |horce_obj, idx|
        ### DBになければHorceモデルを作成
        horce = Horce.find_by(:name => horce_obj.horce_name) || Horce.create!(:name => horce_obj.horce_name)
        if (horceresult = Horceresult.where(race_id: race.id, horce_id: horce.id))
          ### なければhorceresultモデルを作成
          race.horceresults.build(
              :odds => horce_obj.odds,
              :popularity => idx,
              :horce_num => horce_obj.horce_num,
              :frame_num => Util.frame_num_from_horce_num(horce_obj.horce_num),
              :ranking => nil,
              :horce_id => horce.id
          )
        else
          horceresult.update(
              :odds => horce_obj.odds,
              :popularity => idx,
          )
        end
        race.save
      end
    end
  end
end