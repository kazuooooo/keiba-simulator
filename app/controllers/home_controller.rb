class HomeController < ApplicationController
  FruitsBox = Struct.new(:name, :amount)
  FruitsBoxes = []
  def index
  end
  def try_home
  end
  def bet_check
    @odds_data = BetCheckScraper.scrape_odds_data
  end
end
