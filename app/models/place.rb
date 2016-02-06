class Place < ActiveRecord::Base
  has_many :races, dependent: :destroy
  has_many :betconditions, dependent: :destroy
end
