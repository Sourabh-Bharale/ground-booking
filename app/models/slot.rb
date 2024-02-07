class Slot < ApplicationRecord
    # enum status: {
    #     available: "AVAILABLE",
    #     booked: "BOOKED",
    # }
    validates :event_id, presence: true
    validates :time_slot , presence: true , format: { with: /\A\d{1,2}(AM|PM)-\d{1,2}(AM|PM)\z/ }
    validates :status, presence: true , inclusion: { in: %w(AVAILABLE BOOKED) }
end
