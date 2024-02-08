class AddUserRefToRegistration < ActiveRecord::Migration[7.1]
  def change
    add_reference :registrations, :user, null: false, foreign_key: {polymorphic: true}
  end
end
