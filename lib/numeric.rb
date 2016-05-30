class Numeric
  def rounddown(n=1)

    # 数値を文字列に変換
    str = self.to_s

    # 小数点アリ？
    if str.scan(/\./).size > 0 # 小数なら1

      # 小数点で2つに分割
      f1, f2 = str.split(/\./)

      # 後者は最初のn文字だけ取る
      n = 1 if n < 1
      f2 = f2[0..(n-1)]

      # 文字列連結
      s = f1+'.'+f2

      # 数値（小数）へ変換
      f = s.to_f

    else # 整数

      f = self
    end

    f # 小数点2位までの数値or整数を返す
  end
end
