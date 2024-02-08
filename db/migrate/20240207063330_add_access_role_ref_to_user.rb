class AddAccessRoleRefToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :access_role, foreign_key: {polymorphic: true} 
  end
end
