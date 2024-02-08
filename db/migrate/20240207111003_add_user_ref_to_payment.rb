class AddUserRefToPayment < ActiveRecord::Migration[7.1]
  def change
    add_reference :payments, :user, null: false, foreign_key: {polymorphic: true}
  end
end
