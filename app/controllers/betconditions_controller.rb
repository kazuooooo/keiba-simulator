class BetconditionsController < ApplicationController
  def create
    if user_signed_in?
      @betcondition = current_user.betconditions.build(betcondition_params)
    else
      @betcondition = Betcondition.new(betcondition_params)
    end
    mode = @betcondition.mode
    if mode == "try"
      respond_to do |format|
        if @betcondition.save
          format.html { redirect_to try_result_path, notice: 'betcondition was successfully created.' }
        else
          format.html { redirect_to try_path, notice: @betcondition.errors }
        end
      end
    elsif mode == "analyze"
      respond_to do |format|
        if @betcondition.save
          format.html { redirect_to analyze_result_path, notice: 'betcondition was successfully created.' }
        else
          format.html { redirect_to analyze_path, notice: @betcondition.errors }
        end
      end
    end
  end

  def destroy
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def betcondition_params
    params.require(:betcondition).permit(:name,
                                         :place_id,
                                         :start_date,
                                         :end_date,
                                         :mode,
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
