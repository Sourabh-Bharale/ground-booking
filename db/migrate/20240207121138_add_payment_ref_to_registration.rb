class AddPaymentRefToRegistration < ActiveRecord::Migration[7.1]
  def change
    add_reference :registrations, :payment, null: false, foreign_key: {polymorphic: true}
  end
end
