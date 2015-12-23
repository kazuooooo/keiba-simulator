class ResultController < ApplicationController
  def result
    @races = Race.all
  end
end
