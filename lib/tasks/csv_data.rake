require 'csv'
require 'date'
# csv 日付,場所,R,着順,枠番,馬番,人気順,オッズ
# 札幌 | 函館 | 福島 | 新潟 | 東京 | 中山 | 中京 | 京都 | 阪神 | 小倉
namespace :csv_data do
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

  desc "import csv data to DB"
  task :import => :environment do
    # 今あるデータは削除
    Race.delete_all
    Horceresult.delete_all
    Horce.delete_all
    Place.delete_all
    # Placeを作成しておく
    place_hash.each do |place|
      Place.create!(
        :name => place[0]
      )
    end

    # csv処理
    prior_row = nil
    race = nil
    ## ファイルを読み込み
    csv_text = File.read('csv_data/sample.csv')
    ## tableオブジェクトに変換
    CSV.parse(csv_text, :headers => :first_row) do |row|
      ### Placeを使ってRaceをビルド
      place = Place.find_by(:name => row['場所'])
      ### 日付をDateオブジェクトに変換
      date_str = row['日付'].slice(/2.*日/)
      date_obj = Date.strptime(date_str,"%Y年 %m月 %d日")
      ### raceモデルを作成
      if (prior_row.nil?) || (row['R'] != prior_row['R'])
        race = place.races.build(:date => date_obj, :race_num => row['R'])
        place.save
      end

      ### horceresultモデルを作成
      race.horceresults.build(
        :odds => row['オッズ'],
        :popularity => row['人気順'],
        :horce_num => row['馬番'],
        :frame_num => row['枠番'],
        :ranking => row['着順']
      )
      race.save

      ### DBになければHorceモデルを作成
      if Horce.find_by(:name => row['馬名']).nil?
        Horce.create!(:name => row['馬名'])
      end

      ### 1つ前の行を保存
      prior_row = row
    end
  end

  # 場所名からplaceオブジェクトを取得
  def get_place(name)
    Race.find_by(:name)
  end
end
  # create_table "places", force: :cascade do |t|
  #   t.integer  "place_id",   limit: 4
  #   t.string   "name",       limit: 255
  #   t.datetime "created_at",             null: false
  #   t.datetime "updated_at",             null: false
  # end
# create_table "horces", force: :cascade do |t|
#     t.string   "name",       limit: 255
#     t.datetime "created_at",             null: false
#     t.datetime "updated_at",             null: false
#     t.integer  "horce_id",   limit: 4
#   end

  # create_table "horceresults", force: :cascade do |t|
  #   t.integer  "race_id",    limit: 4
  #   t.integer  "horce_id",   limit: 4
  #   t.float    "odds",       limit: 24
  #   t.integer  "popularity", limit: 4
  #   t.integer  "horce_num",  limit: 4
  #   t.integer  "frame_num",  limit: 4
  #   t.integer  "ranking",    limit: 4
  #   t.datetime "created_at",            null: false
  #   t.datetime "updated_at",            null: false
  # end
