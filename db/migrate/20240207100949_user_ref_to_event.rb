class UserRefToEvent < ActiveRecord::Migration[7.1]
  def change
    add_reference :events, :user, foreign_key: {polymorphic: true}
  end
end
