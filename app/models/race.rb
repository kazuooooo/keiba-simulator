class Race < ActiveRecord::Base
  belongs_to :place
  has_many :horceresults, dependent: :destroy

  def sort_by_horce_result(key)
    self.horceresults.sort_by { |horceresult| horceresult[key] }
  end

  scope :horces_count, ->(count) {
    joins(:horceresults)
        .select('races.id, count(horceresults.id) as horce_count')
        .group('races.id')
        .having('horce_count = ?', count)
  }
end
