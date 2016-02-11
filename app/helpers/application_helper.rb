module ApplicationHelper
  def unify_date_vals(year, month, day)
    Date.new(params[action]['date_from(1i)'].to_i,
             params[action]['date_from(2i)'].to_i,
             params[action]['date_from(3i)'].to_i,
            )
  end

  def header_user_name
    user_signed_in? ? current_user.email : "ゲスト"
  end
end
