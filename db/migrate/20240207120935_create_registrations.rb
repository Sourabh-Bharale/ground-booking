class CreateRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :registrations do |t|
      t.string :status
      t.string :receipt_url

      t.timestamps
    end
  end
end
