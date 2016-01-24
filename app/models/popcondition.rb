class Popcondition < ActiveRecord::Base
  belongs_to :betcondition
  has_many :oddsranges
  accepts_nested_attributes_for :oddsranges
end
