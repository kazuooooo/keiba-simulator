class BetconditionsController < ApplicationController
  def create
    @betcondition = Betcondition.new(betcondition_params)
    # @betcondition.build_popcondition
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
    params.require(:betcondition).permit(:place_id,
                                         :start_date,
                                         :end_date,
                                         :popconditions_attributes => [:id,
                                                                       :popularity,
                                                                       :betcondition_id,
                                                                       :odds_start,
                                                                       :odds_end,
                                                                       :_destroy,
                                                                       ]
                                        )
  end

end
