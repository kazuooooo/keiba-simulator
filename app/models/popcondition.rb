class Popcondition < ActiveRecord::Base
  belongs_to :betcondition

  def meet_condition?(odds)
    odds.between?(self.odds_start, self.odds_end)
  end
end
