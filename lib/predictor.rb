# could be use NArray
class Predictor
  # 日本語形式の日付に変換
  # @param [Date] date 日付
  # @return [String] 日付を YYYY年MM月DD日 の形式にしたもの
  def self.predict(csv_file_name)
    # pythonの予測スクリプトを実行(結果をcsvファイルとして保存)
    exec("python #{Rails.root}/predict_python/predict.py params")
    puts "foobar"
    # 保存されたcsvファイルを読み込んで配列に変換
    p_predict  = []
    op_predict = []
    CSV.foreach("#{Rails.root}/result_p.csv") do |row|
      1+1
      binding.pry
    end
    # 配列を返す
    %w(a b c)
  end
end