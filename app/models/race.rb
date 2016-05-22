class Race < ActiveRecord::Base
  belongs_to :place
  has_many :horceresults, dependent: :destroy

  COURSE = {
      "ダート" => -1,
      "芝"   => 1,
  }

  COURSE_CONDITION = {
      "良"  => 2,
      "稍重" => 1,
      "重"  => -1,
      "不良" => -2
  }

  ROTATION = {
      "右"  => -1,
      "直線" => 0,
      "左"  => 1,
      ""   => 0 #障害走
  }

  WEATHER = {
      "晴"  => 1,
      "曇"  => 0,
      "雨"  => -1,
      "小雪" => -1,
      "小雨" => -1,
  }

  scope :horces_count, ->(count) {
    joins(:horceresults)
        .select('races.id, count(horceresults.id) as horce_count')
        .group('races.id')
        .having('horce_count = ?', count)
  }

  def sort_by_horce_result(key)
    self.horceresults.sort_by { |horceresult| horceresult[key] }
  end

  def self.convert_string_to_numeral_value(column, value)
    case column
      when :course
        COURSE[value]
      when :rotation
        ROTATION[value]
      when :weather
        WEATHER[value]
      when :course_condition
        COURSE_CONDITION[value]
    end
  end

end
