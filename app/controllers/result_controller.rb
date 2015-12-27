class ResultController < ApplicationController
  def result
    @result = params[:result][:year]
  end
end
