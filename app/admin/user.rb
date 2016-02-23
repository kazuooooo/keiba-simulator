ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  config.sort_order = 'email_asc'
  index do
    id_column
    column :email
    column :created_at
    actions
  end

  scope :test

  filter :email, as: :check_boxes, collection: proc { User.all.map(&:email) }, label: "hello"
  index as: :grid, columns: 5 do |user|
    link_to image_tag('horce_sample.png'), admin_user_path(user)
  end

  form do |f|
    inputs 'Email' do
      input :email
      li "Created at #{f.object.created_at}" unless f.object.new_record?
    end
    panel 'Markup' do
      "The following can be used in the content below..."
    end
    para "Press cancel to return to the list without saving."
    actions
  end

  show do
    panel "Table of Contents" do
      table_for user.betconditions do
        column :name
      end
    end
    active_admin_comments
  end

  sidebar "Details", only: :show do
    attributes_table_for user.betconditions do
      row :name
      row :start_date
      row :place_id
    end
  end

  # デフォルトのアクションに新たにアクションを追加する(actionsでボタンとかができる)
  action_item :c_test_action, only: :show do
    link_to 'View on site', c_test_action_admin_users_path
  end

  # リソースに対するアクションを定義する
  collection_action :c_test_action, method: :get do
    # Do some CSV importing work here...
    redirect_to collection_path, notice: "CSV imported successfully!"
  end

end
