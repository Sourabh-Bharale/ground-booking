class AddEventRefToSlot < ActiveRecord::Migration[7.1]
  def change
    add_reference :slots, :event, null: false, foreign_key: {polymorphic: true}
  end
end
