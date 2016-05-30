require 'rails_helper'
require "webmock/rspec"
# これをつけておくとEXAMPLE_SITE_URL以外は普通にWebにアクセス
# すべてのhttpリクエストを行わない場合は、下を削除
# WebMock.allow_net_connect!
#
# D_ACCESS_URL = "http://www.jra.go.jp/JRADB/accessD.html" #これ書いてると普通のリクエストもきかんくなるかも

describe 'scrape from races' do
  # before do はexampleの実行前に呼ばれる
  before do
    # EXAMPLE_SITE_URL にアクセスしたら EXAMPLE_SITE_BODY を返すスタブを作成
    # stub_request(:post, D_ACCESS_URL).with(body: {data: {'cname' => 'pw01dli00/F3'}}).to_raise(StandardError)
  end
  describe '#scrape_race_data' do
    it 'it return Hash' do
      result = DataScraper.scrape_race_data(5, 28)
      expect(result).to be_kind_of(Hash)
    end
    it 'Array is DataScraper:StruceRace class' do
      result = DataScraper.scrape_race_data(5, 28)
      # expect(result.sample).to be_kind_of(DataScraper::ScrapedRace)
    end
  end


  # describe 'private#get_race_cnames_from_AccessD' do
  #   sample_page = "hoge"
  #   result = DataScraper.get_race_cnames_from_AccessD(sample_page)
  #   it 'it return Array' do
  #     expect(result).to be_kind_of(Array)
  #   end
  #   it 'array content start with pw' do
  #     expect(result.sample).to match(/^pw.*/)
  #   end
  # end
  #
  # describe 'private#scrape_from_race_page' do
  #   page_body = "hote"
  #   result = DataScraper.scrape_from_race_page(page_body)
  #   it 'result is DataScraper:StruceRace class' do
  #     expect(result).to be_kind_of(DataScraper::ScrapedRace)
  #   end
  #   it 'result has start_time' do
  #     expect(result.start_time).to be_present
  #   end
  #   it 'result has rotation' do
  #     expect(result.rotation).to be_present
  #   end
  #   it 'result has distance' do
  #     expect(result.distance).to be_present
  #   end
  #   it 'result has course' do
  #     expect(result.course).to be_present
  #   end
  # end
  # テスト用のフィード
  EXAMPLE_SITE_BODY = <<-EOF
<!doctype html>
<html>
<head>
  <title>Koreha Example Domain</title>

  <meta charset="utf-8" />
  <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style type="text/css">
  body {
    background-color: #f0f0f2;
    margin: 0;
    padding: 0;
    font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;

  }
  div {
    width: 600px;
    margin: 5em auto;
    padding: 3em;
    background-color: #fff;
    border-radius: 1em;
  }
  a:link, a:visited {
    color: #38488f;
    text-decoration: none;
  }
  @media (max-width: 600px) {
    body {
      background-color: #fff;
    }
    div {
      width: auto;
      margin: 0 auto;
      border-radius: 0;
      padding: 1em;
    }
  }
  </style>
</head>

<body>
<div>
  <h1>Example Domain</h1>
  <p>This domain is established to be used for illustrative examples in documents. You do not need to
    coordinate or ask for permission to use this domain in examples, and it is not available for
    registration.</p>
  <p><a href="http://www.iana.org/domains/special">More information...</a></p>
</div>
</body>
</html>
  EOF
end
