class ChangeAccessRoleRole < ActiveRecord::Migration[7.1]
  def change
    change_column(:access_roles, :role, :string , default: "USER")
  end
end
