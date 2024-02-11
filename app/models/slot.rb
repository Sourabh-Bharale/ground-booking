class Slot < ApplicationRecord
    belongs_to :event
    has_one :registration
    validates :event_id, presence: true
    validates :time_slot , presence: true , format: { with: /\A\d{1,2}(AM|PM)-\d{1,2}(AM|PM)\z/ }
    validates :status, presence: true , inclusion: { in: %w(AVAILABLE BOOKED) }
end
