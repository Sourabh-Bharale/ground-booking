class AddRoleToAccessRole < ActiveRecord::Migration[7.1]
  def change
    add_column :access_roles, :role, :integer, default: 0
  end
end
