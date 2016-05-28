module SeoHelper
  # canonical url
  def canonical_url
  end

  # 各ページ毎のデスクリプション
  def page_description
    t("meta.description.#{controller_name}.#{action_name}")
  end

  # 各ページ毎の代表画像
  def page_og_image
    "#{Settings.site.url}#{Settings.site.meta.og.image}"
  end

  # 各ページ毎のキーワード
  def page_keywords
    t("meta.keywords.#{controller_name}.#{action_name}")
  end

  # 各ページ毎のタイトル
  def page_title
    t("meta.title.#{controller_name}.#{action_name}")
  end
end