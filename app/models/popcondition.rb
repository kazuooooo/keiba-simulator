class Popcondition < ActiveRecord::Base
  belongs_to :betcondition
  has_many :oddsranges
end
