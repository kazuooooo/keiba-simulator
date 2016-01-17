class Betcondition < ActiveRecord::Base
  belongs_to :place
  has_many :popconditions
end
