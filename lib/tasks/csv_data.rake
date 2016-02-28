require 'csv'
require 'date'

namespace :csv_data do
  desc "import csv data to DB"
  #tmp task :import, 'file_name'
  task :import => :environment do |task, args|
    clear_data()
    # create_place_table()
    for num in [2013] do
      import_csv_data(num.to_s)
    end
  end
end

def clear_data
  Race.delete_all
  Horceresult.delete_all
  Horce.delete_all
  # Place.delete_all
end

def create_place_table

  place_hash = {
    "札幌" => 1,
    "函館" => 2,
    "福島" => 3,
    "新潟" => 4,
    "東京" => 5,
    "中山" => 6,
    "中京" => 7,
    "京都" => 8,
    "阪神" => 9,
    "小倉" => 10,
   }

  place_hash.each do |place|
    Place.create!(
      :name => place[0]
    )
  end

end

def import_csv_data(file_name)
  puts "start" << file_name
  prior_row = nil
  race = nil

  ## ファイルを読み込み
  csv_text = File.read('csv_data/' << file_name << '.csv')

  ## tableオブジェクトに変換してtableデータを作成
  CSV.parse(csv_text, :headers => :first_row) do |row|
    ### Placeを使ってRaceをビルド
    place = Place.find_by(:name => row['場所'])
    ### 日付をDateオブジェクトに変換
    date_str = row['日付'].slice(/[1|2].*日/)
    date_obj = Date.strptime(date_str,"%Y年 %m月 %d日")
    ### raceモデルを作成
    if (prior_row.nil?) || (row['R'] != prior_row['R'])
      race = place.races.build(:date => date_obj, :race_num => row['R'], :race_name => row['レース名'])
      place.save
    end

    ### DBになければHorceモデルを作成
    horce = Horce.find_by(:name => row['馬名']) || Horce.create!(:name => row['馬名'])

    ### horceresultモデルを作成
    race.horceresults.build(
      :odds => row['オッズ'],
      :popularity => row['人気順'],
      :horce_num => row['馬番'],
      :frame_num => row['枠番'],
      :ranking => row['着順'],
      :horce_id => horce.id
    )
    race.save
    ### 1つ前の行を保存
    prior_row = row
  end

  puts "end" << file_name
end
