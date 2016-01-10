require 'mechanize'
require 'pry'
# 最新のオッズ情報を取得して返す
class BetCheckScraper

  class Race < Struct.new(:date, :place, :race_num); end
  class Horce < Struct.new(:ranking, :frame_num, :horce_num, :horce_name, :popularity, :odds); end

  def scrape
    # ペーじ取得
    agent = Mechanize.new
    odds_home = agent.get('http://race.netkeiba.com/')
    binding.pry
    # 今日の各競馬場のリンクをクリック
    place_home_pages = get_place_home_pages(odds_home)

    # 各競馬場に対して最新のオッズを取得
    places_odds = place_home_pages.map do |place_home_page|
                    get_races_odds(place_home_page)
                  end
  end
end
#<Mechanize::Page::Link "1/10(日)" "/keiba/calendar/2016/1/0110.html">

def get_place_home_pages(odds_home)
  place_home_links = odds_home.links.select do |link|
                       /#{Time.now.month}\/#{Time.now.mday}/ === link.text
                     end
  binding.pry
  place_home_pages = place_home_links.map{ |link| begin link.click rescue retry end}
end

def get_races_odds(place_home_page)
  race_pages = get_race_pages(place_home_page)
  races_odds = race_pages.map do |race_page|
                 scrape_race_odds(race_page)
               end
end

def get_race_pages(place_home_page)

end

def scrape_race_odds(race_page)

end

BetCheckScraper.new.scrape

