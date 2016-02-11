class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
  end

  def upanel
    @time = Time.now.to_s
  end
end
