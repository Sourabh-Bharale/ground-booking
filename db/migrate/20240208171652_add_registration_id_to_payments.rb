class AddRegistrationIdToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :registration_id, :integer
  end
end
