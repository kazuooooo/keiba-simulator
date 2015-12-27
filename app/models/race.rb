class Race < ActiveRecord::Base
  belongs_to :place
  has_many :horceresults, dependent: :destroy
end
