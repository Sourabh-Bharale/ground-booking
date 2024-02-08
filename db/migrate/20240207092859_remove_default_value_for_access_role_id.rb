class RemoveDefaultValueForAccessRoleId < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :access_role_id, nil
  end
end
