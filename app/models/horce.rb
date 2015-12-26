class Horce < ActiveRecord::Base
  has_many :horceresults, dependent: :destroy
end
