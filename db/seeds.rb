# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Race.create(
              :date => '2011-11-14',
              :place => '大阪',
              :race_num => '1',
              :ranking => '3',
              :frame_num => '4',
              :horce_num => '5',
              :popularity => '6',
              :odds => '1.8'
              )
Race.create(
              :date => '2015-12-25',
              :place => '東京',
              :race_num => '2',
              :ranking => '8',
              :frame_num => '6',
              :horce_num => '7',
              :popularity => '9',
              :odds => '1.8'
              )
