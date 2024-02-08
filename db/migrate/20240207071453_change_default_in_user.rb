class ChangeDefaultInUser < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :access_role_id, 3
  end
end
