class HomeController < ApplicationController

  def index
  end

  def analyze
  end

  def try_home
    @bet_condition = Betcondition.new
  end

  def upanel
    @time = Time.now.to_s
  end
end
