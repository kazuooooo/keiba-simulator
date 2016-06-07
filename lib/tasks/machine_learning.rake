require 'csv'
require 'date'

namespace :machine_learning do
  # DBからmachine_learning_dataを作成
  desc "create machine learning data"
  task :create, ['date_from', 'date_to', 'players'] => :environment do |task, args|
    args.with_defaults(players: 16)
    # rowデータ作成
    puts "makingrows..."
    @rows = DataMaker.create_row_data(date_from: args[:date_from], date_to: args[:date_to], players: args[:players])
    # csv吐き出し
    puts "output csv"
    DataMaker.output_csv_data(@rows)
  end

  # 1. Webサイトのデータからmachine_learning_data.csvを作成
  # 1. Race, Horceresultテーブルを更新
  desc "get todays race data from JRA web site"
  task :output_today_data, ['month', 'date'] => :environment do |task, args|
    month = args[:month].presence || Date.today.month
    date  = args[:day].presence || Date.today.day
    scraped_data = DataScraper.scrape_machine_learning_data(month.to_i, date.to_i)
    row_data = DataMaker.create_row_data_for_webscrape(scraped_data)
    # Race, Horceを生成
    DataMaker.create_raceobjs(row_data)
    DataMaker.output_csv_data(row_data)
  end

  # 2. machine_learning_data.csvを読み取って予想データpredict.csvを作成
  desc "make predict data by running python script"
  task :make_predict_data => :environment do |task, args|

  end

  # 3. predict.csvを読み取ってRacePredictテーブルを更新
  desc "update RacePredict"
  task :update_race_predict => :environment do |task, args|

  end

  desc "cron test"
  task :test_cron => :environment do |task, args|
    puts "hello cron"
  end
end