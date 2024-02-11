class ChangePaymentIdInRegistration < ActiveRecord::Migration[7.1]
  def change
    change_column :registrations, :payment_id, :integer , null: true
  end
end
