class BetcheckController < ApplicationController
  before_action :set_odds_data
  before_action :set_bet_conditions, only: [:index]
  before_action :set_selected_bet_conodition, only: [:color_targets]
  def index
  end

  def color_targets
    @time = Time.now.to_s
  end

  private
  def set_odds_data
    @odds_data      = DataScraper.scrape_odds_data(Date.today.month, Date.today.day)
  end

  def set_bet_conditions
    if user_signed_in?
      @bet_conditions = current_user.betconditions.includes(:popconditions).includes(:place)
    end
  end

  def set_selected_bet_conodition
    @bet_condition = Betcondition.find(params[:bc_id])
    @place         = @bet_condition.place.name
  end

  def has_race?(place)
    @odds_data.has_key?(place) if @odds_data
  end
  helper_method :has_race?
end
