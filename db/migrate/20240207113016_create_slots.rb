class CreateSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.string :time_slot
      t.string :status

      t.timestamps
    end
  end
end
