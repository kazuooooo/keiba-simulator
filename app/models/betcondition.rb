class Betcondition < ActiveRecord::Base
  belongs_to :place
  belongs_to :user
  has_many :popconditions
  accepts_nested_attributes_for :popconditions, allow_destroy: true
  # validations
  validates :name,
    presence: true
  validates :place_id,
    presence: true
  validates :start_date,
    presence: true,
    timeliness: {
                  before: :end_date,
                }
  validates :end_date,
    presence: true,
    timeliness: {
                  after: :start_date,
                  before: Date.today
                }


  def meet_condition?(pop_rank, odds)
    # 対象の人気順のpop_conditionを配列で抽出(同じ人気順に複数指定できるように)
    target_pop_conditions = popconditions.select{|popcondition| popcondition.popularity == pop_rank}
    # pop_rankがpopconditions内にない場合はreturn
    if target_pop_conditions.empty?
      return false
    end
    # 抽出したpopconditionにoddsが条件を満たしているか検証
    target_pop_conditions.each do |popcondition|
      @result = popcondition.meet_condition?(odds)
      if @result
        break
      end
    end
    @result
  end
end

# create_table "betconditions", force: :cascade do |t|
#   t.integer  "place_id",   limit: 4
#   t.date     "start_date"
#   t.date     "end_date"
#   t.datetime "created_at",             null: false
#   t.datetime "updated_at",             null: false
#   t.string   "name",       limit: 255
# end
