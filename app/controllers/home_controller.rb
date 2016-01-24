class HomeController < ApplicationController
  def index
  end

  def analyze
  end

  def try_home
  end
  def bet_check
    @odds_data = BetCheckScraper.scrape_odds_data
  end
end
