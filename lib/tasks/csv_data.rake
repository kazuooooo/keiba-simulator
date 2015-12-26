namespace :csv_data do
  desc "import csv data to DB"

  task :import => :environment do
    puts "hello task"
  end
end
