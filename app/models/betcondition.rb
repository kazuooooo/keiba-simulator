class Betcondition < ActiveRecord::Base
  belongs_to :place
  has_many :popconditions
  accepts_nested_attributes_for :popconditions, allow_destroy: true
end
