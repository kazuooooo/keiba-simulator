class BetconditionsController < ApplicationController
  def create
    binding.pry
    @betcondition = Betcondition.new(betcondition_params)
    @betcondition.build_popcondition
    respond_to do |format|
      if @betcondition.save
        format.html { redirect_to root_path, notice: 'betcondition was successfully created.' }
      else
        format.html { redirect_to root_path, notice: 'betcondition was failed to create.' }
      end
    end
  end

  def destroy
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def betcondition_params
    binding.pry
    params.require(:betcondition).permit(:place_id,
                                         :start_date,
                                         :end_date,
                                         :popcondition => [:popularity])
  end

end
