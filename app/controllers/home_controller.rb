class HomeController < ApplicationController
  def index
    @betcondition = Betcondition.new
    # ちょっと一旦Scafoldの作りかた見たほうがいい
  end

  def try_home
  end
  def bet_check
    @odds_data = BetCheckScraper.scrape_odds_data
  end
end
