require 'mechanize'
require 'pry'

# 最新のオッズ情報を取得して返す
class BetCheckScraper

  class Race < Struct.new(:title, :race_num, :horce_objs); end
  class Horce < Struct.new(:horce_num, :horce_name, :tansyo, :fukusyo_min, :fukusyo_max); end

  def scrape
    # ぺージ取得
    agent = Mechanize.new
    # オッズぺージにアクセス
    agent.post('http://www.jra.go.jp/JRADB/accessO.html', {
                "cname" => "pw15oli00/6D"
              })
    # 中山にアクセス
    agent.post('http://www.jra.go.jp/JRADB/accessO.html', {
                "cname" => "pw15orl10062016010320160110/B3"
              })
    # 各レースのcname値を取得
    html_nakayama = Nokogiri::HTML(agent.page.body)
    race_post_values = html_nakayama.css('.raceList2Area tr td.raceNo a').map do |link|
                         link.attributes["onclick"].value.match(/'p.*'/).to_s.gsub("\'", "")
                       end
    races = []
    # 各Rリンクに対して
    race_post_values.each do |race_post_value|
      # アクセスする
      agent.post('http://www.jra.go.jp/JRADB/accessO.html',
                  { "cname" => race_post_value }
                )
      # データをスクレイピングする
      races << scraping_data(agent.page.body)
      # 戻る
      agent.back
    end
  end

  def scraping_data(page_body)
    # データをスクレイピング
    html = Nokogiri::HTML(page_body)

    # 馬情報
    horces = html.css('.ozTanfukuTableUma tr:not(:first-child)')
    horce_objs = horces.map do |horce|
                   Horce.new(
                    horce.css('.umaban').inner_text,
                    horce.css('.bamei').inner_text,
                    horce.css('.oztan').inner_text.lstrip,
                    horce.css('.fukuMin').inner_text.lstrip,
                    horce.css('.fukuMax').inner_text.lstrip
                   )
                 end

    # レース情報
    race_obj = Race.new(
                 html.css('.raceTtlTable tr').inner_text.strip,
                 html.css('.raceNMTable tr > td').inner_text.strip,
                 horce_objs
               )
  end
end
sample = BetCheckScraper.new.scrape
