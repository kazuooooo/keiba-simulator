require 'mechanize'

# 最新のオッズ情報を取得して返す
module BetCheckScraper
  include Util
  class StructRace < Struct.new(:title, :race_num, :horce_objs); end
  class StructHorce < Struct.new(:horce_num, :horce_name, :tansyo, :fukusyo_min, :fukusyo_max); end

  def scrape_odds_data
    agent = Mechanize.new
    # オッズぺージにアクセス
    agent.post('http://www.jra.go.jp/JRADB/accessO.html', {
                "cname" => "pw15oli00/6D"
              })
    # 今日レースのある会場のcnameを配列で取得
    html_odds_home = Nokogiri::HTML(agent.page.body)
    # 今日のthを取得
    today_th_node = html_odds_home.css(".joSelect tr th").select {|n| n.text =~ /#{Date.today.month}月#{Date.today.day}日/}

    place_cname_hash = {}
    today_th_node[0].next.next.css(".kaisaiBtn.btn").each do |node|
      place = Util.extract_place(node.children[0].children[2].text)
      cname = node.children[0].attributes["onclick"].value.match(/'pw.*'/).to_s.delete("'")
      place_cname_hash[place] = cname
    end

    place_result_hash = {}
    place_cname_hash.each do |place, cname|
      # TODO: 各場所でもう一段階ネストさせる
      agent.post('http://www.jra.go.jp/JRADB/accessO.html', {
                  "cname" => cname
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
      place_result_hash[place] = races
    end
    place_result_hash
  end

  def scraping_data(page_body)
    # データをスクレイピング
    html = Nokogiri::HTML(page_body)

    # 馬情報
    horces = html.css('.ozTanfukuTableUma tr:not(:first-child)')
    horce_objs = horces.map do |horce|
                   StructHorce.new(
                    horce.css('.umaban').inner_text.to_i,
                    horce.css('.bamei').inner_text,
                    horce.css('.oztan').inner_text.lstrip.to_f,
                    horce.css('.fukuMin').inner_text.lstrip.to_f,
                    horce.css('.fukuMax').inner_text.lstrip.to_f
                   )
                 end

    # レース情報
    race_obj = StructRace.new(
                 html.css('.raceTtlTable tr').inner_text.strip,
                 html.css('.raceNMTable tr > td').inner_text.strip,
                 horce_objs
               )
  end
  module_function :scrape_odds_data, :scraping_data
end
