class AddSlotRefToRegistration < ActiveRecord::Migration[7.1]
  def change
    add_reference :registrations, :slot, null: false, foreign_key: {polymorphic: true}
  end
end
