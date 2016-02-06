class Betcondition < ActiveRecord::Base
  belongs_to :place
  has_many :popconditions
  accepts_nested_attributes_for :popconditions, allow_destroy: true

  def meet_condition?(pop_rank, odds)
    # 対象の人気順のpop_conditionを配列で抽出(同じ人気順に複数指定できるように)
    pop_conditions = self.popconditions.select{|popcondition| popcondition.popularity == pop_rank}
    # 抽出したpopconditionにoddsが条件を満たしているか検証
    popconditions.each do |popcondition|
      @result = popcondition.meet_condition?(odds)
      if @result
        break
      end
    end
    @result
  end
end
