require 'mechanize'

# 必要なデータをWebサイトからスクレイピングする
module DataScraper
  include Util
  class Scraped
    def initialize(initial_props)
      initial_props.each do |prop_name, prop_value|
        self.send("#{prop_name}=",prop_value)
      end
    end
  end
  class ScrapedRace < Scraped
    attr_accessor :title, :race_num, :start_time, :distance, :course, :rotation, :horce_objs, :race_name
    def to_h
      hash = {}
      instance_variables.each do |val|
        hash[val.to_s.delete("@")] = self.send(val.to_s.delete("@"))
      end
      hash
    end
  end
  class ScrapedHorce < Scraped
    attr_accessor :horce_num, :horce_name, :odds, :fukusyo_min, :fukusyo_max
  end

  def scrape_machine_learning_data(month,day)
    odds_data = scrape_odds_data(month, day)
    race_data = scrape_race_data(month, day)
    merged_data = merge_data(odds_data, race_data)
  end

  def scrape_odds_data(month, day)
    agent = Mechanize.new
    # オッズぺージにアクセス
    agent.post('http://www.jra.go.jp/JRADB/accessO.html', {
        "cname" => "pw15oli00/6D"
    })
    # 今日レースのある会場のcnameを配列で取得
    html_odds_home = Nokogiri::HTML(agent.page.body)
    # 今日のthを取得
    today_th_node  = html_odds_home.css(".joSelect tr th").select { |n| n.text =~ /#{month}月#{day}日/ }
    # 今日レースがない場合はリターンさせる
    return nil if today_th_node.size.zero?
    # (デバッグ用)
    # today_th_node = html_odds_home.css(".joSelect tr th").select {|n| n.text =~ /1月30日/}

    place_cname_hash = {}
    today_th_node[0].next.next.css(".kaisaiBtn.btn").each do |node|
      place                   = Util.extract_place(node.children[0].children[2].text)
      cname                   = node.children[0].attributes["onclick"].value.match(/'pw.*'/).to_s.delete("'")
      place_cname_hash[place] = cname
    end

    place_result_hash = {}
    place_cname_hash.each do |place, cname|
      # TODO: 各場所でもう一段階ネストさせる
      agent.post('http://www.jra.go.jp/JRADB/accessO.html', {
          "cname" => cname
      })
      # 各レースのcname値を取得
      html_nakayama    = Nokogiri::HTML(agent.page.body)
      race_post_values = html_nakayama.css('.raceList2Area tr td.raceNo a').map do |link|
        link.attributes["onclick"].value.match(/'p.*'/).to_s.gsub("\'", "")
      end
      races            = []
      # 各Rリンクに対して
      race_post_values.each do |race_post_value|
        # アクセスする
        agent.post('http://www.jra.go.jp/JRADB/accessO.html',
                   { "cname" => race_post_value }
        )
        # データをスクレイピングする
        races << scrape_from_odds_page(agent.page.body)
        # 戻る
        agent.back
      end
      place_result_hash[place] = races
    end
    place_result_hash
  end

  # 出馬表ページからレース情報を取得
  def scrape_race_data(month, day)
    agent = Mechanize.new
    url   = 'http://www.jra.go.jp/JRADB/accessD.html'
    place_races_hash = {}
    # 出馬表ページにアクセス
    agent.post(url, {
        "cname" => "pw01dli00/F3"
    })
    html_races_home  = Nokogiri::HTML(agent.page.body)
    select_day_ths   = html_races_home.css("th").select { |n| n.text =~ /#{month}月#{day}日/ }
    # レースがある場所のcnameを取得
    place_cname_hash = {}
    select_day_ths[0].next.next.css(".kaisaiBtn a").each do |node|
      place                   = Util.extract_place(node.children.text)
      cname                   = node.attributes["onclick"].value.match(/'pw.*'/).to_s.delete("'")
      place_cname_hash[place] = cname
    end
    #
    # # 各レース場に対して
    place_cname_hash.each do |place, cname|
      races = []
      # レース場のレース一覧ページにアクセス
      agent.post(url, {
          "cname" => cname
      })
      # # cnamesを取得
      place_home_page = Nokogiri::HTML(agent.page.body)
      cnames_array    = get_race_cnames_from_AccessD(place_home_page)
      # 各レースページにアクセス
      cnames_array.each do |cname|
        # ページにアクセス
        agent.post(url, {
            cname: cname
        })
        race_page = Nokogiri::HTML(agent.page.body)
        races << scrape_from_race_page(race_page)
        # 1個戻る
        agent.back
      end
      place_races_hash[place] = races
    end
    place_races_hash
  end

  private
  def get_race_cnames_from_AccessD(page_body)
    cname_array = []
    races       = page_body.css(".raceList a")
    races.each do |race|
      cname = race.attributes["onclick"].value.match(/'pw.*'/).to_s.delete("'")
      cname_array << cname if cname.size >= 32
    end
    cname_array
  end

  def scrape_from_race_page(body)
    distance         = body.css(".raceData td")[1].text.split("　")[0]
    course, rotation = body.css(".raceData td")[1].text.split("　")[1].split("・")
    start_time       = body.css(".raceData td").last.text.match(/\d{2}:\d{2}/).to_s
    race_name = body.css(".raceData td").first.text
    race_obj  = DataScraper::ScrapedRace.new({
        distance: distance,
        course: course,
        rotation: rotation,
        start_time: start_time,
        race_name: race_name
                                             })
  end

  # オッズページからデータを取得する
  def scrape_from_odds_page(page_body)
    # データをスクレイピング
    html       = Nokogiri::HTML(page_body)

    # 馬情報
    horces     = html.css('.ozTanfukuTableUma tr:not(:first-child)')
    horce_objs = horces.map do |horce|
      DataScraper::ScrapedHorce.new(
          horce_num:   horce.css('.umaban').inner_text.to_i,
          horce_name:  horce.css('.bamei').inner_text,
          odds:        horce.css('.oztan').inner_text.lstrip.to_f,
          fukusyo_min: horce.css('.fukuMin').inner_text.lstrip.to_f,
          fukusyo_max: horce.css('.fukuMax').inner_text.lstrip.to_f
      )
    end

    # レース情報
    race_obj   = DataScraper::ScrapedRace.new(
        title: html.css('.raceTtlTable tr').inner_text.strip,
        race_num: html.css('.raceNMTable tr > td').inner_text.strip.match(/^\d{1,2}/).to_s,
        horce_objs: horce_objs
    )
  end

  def merge_data(odds_page_scraped_data, race_page_scraped_data)
    merge_data = {}
    race_page_scraped_data.each do |place, race_page_place_data|
      races = []
      odds_page_place_data = odds_page_scraped_data[place]
      race_page_place_data.each_with_index do |race, idx|
        merged_props = race.to_h.merge(odds_page_place_data[idx].to_h)
        races << DataScraper::ScrapedRace.new(merged_props)
      end
      merge_data[place] = races
    end
    merge_data
  end
  module_function :scrape_machine_learning_data, :scrape_odds_data, :scrape_from_odds_page, :scrape_race_data, :scrape_from_race_page, :get_race_cnames_from_AccessD, :merge_data
end
