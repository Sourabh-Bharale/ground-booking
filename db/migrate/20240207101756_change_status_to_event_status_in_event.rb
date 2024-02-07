class ChangeStatusToEventStatusInEvent < ActiveRecord::Migration[7.1]
  def change
    rename_column :events, :status, :event_status
  end
end
