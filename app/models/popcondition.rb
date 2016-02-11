class Popcondition < ActiveRecord::Base
  belongs_to :betcondition

  # validation
  validates :popularity,
    presence: true
  validates :odds_start,
    presence: true,
    numericality: {greater_than_or_equal_to: 0}
  validates :odds_end,
    presence: true,
    numericality: {greater_than: :odds_start}

  def meet_condition?(odds)
    odds.between?(self.odds_start, self.odds_end)
  end
end

# create_table "popconditions", force: :cascade do |t|
#   t.integer  "popularity",      limit: 4
#   t.datetime "created_at",                               null: false
#   t.datetime "updated_at",                               null: false
#   t.integer  "betcondition_id", limit: 4
#   t.decimal  "odds_start",                precision: 10
#   t.decimal  "odds_end",                  precision: 10
# end
