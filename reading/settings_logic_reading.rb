# メタプログラミンで辛いけどこんな感じのメソッドが実装されているはず
# settings.ymlが以下のようになっている
# defaults: &defaults
# foo:
#     bar: "bar"
#     hoge:
#         val: "val"
#     b_c: "b_c"
# a:
#     b:
#     c: "yeah!!"
# メタプログラミングのところ
# settingslogic.rb:193
def foo
  return @foo if @foo
  return missing_key("Missing setting 'foo' in #{@section}") unless has_key? 'foo'
  # 与えられたkeyでfetchするfooでfetchするとこのhashが返る
  # {
  #     "bar" => "bar",
  #     "hoge" => {
  #         "val" => "val",
  #         "b_c" => "b_c"
  #     }
  # }
  value = fetch('foo')
  # valueの値によって処理を分ける
  @foo = if value.is_a?(Hash)
    # Hashの場合はさらに階層を潜って自身をnewこのとき第二引数にsectionを指定している
    self.class.new(value, "'foo' section in #{@section}")
  elsif value.is_a?(Array) && value.all?{|v| v.is_a? Hash}
    # Hashの配列の場合(どういう書き方でここに入ってくるかはよくわからない)
    value.map{|v| self.class.new(v)}
  else
    # そのまま値を返す
    value
  end
end