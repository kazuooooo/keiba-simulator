class HomeController < ApplicationController

  def index
  end

  def analyze
  end

  def try_home
    @bet_condition = Betcondition.new
  end

  def bet_check
    @odds_data      = BetCheckScraper.scrape_odds_data
    @bet_conditions = Betcondition.all
  end

  def upanel
    @time = Time.now.to_s
  end
end
