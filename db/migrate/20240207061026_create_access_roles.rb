class CreateAccessRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :access_roles do |t|
      t.timestamps
    end
  end
end
