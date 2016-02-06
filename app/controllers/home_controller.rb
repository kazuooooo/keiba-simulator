class HomeController < ApplicationController

  def index
  end

  def try_home
    @bet_condition = Betcondition.new
  end

  def upanel
    @time = Time.now.to_s
  end
end
