class HomeController < ApplicationController

  def index
  end

  def upanel
    @time = Time.now.to_s
  end
end
