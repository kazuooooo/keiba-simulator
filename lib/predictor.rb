# could be use NArray
class Predictor
  # 日本語形式の日付に変換
  # @param [Date] date 日付
  # @return [String] 日付を YYYY年MM月DD日 の形式にしたもの
  def self.make_predict_data(csv_file_name)
    # pythonの予測スクリプトを実行(結果をcsvファイルとして保存)
    exec("python #{Rails.root}/predict_python/predict.py params")
  end
end