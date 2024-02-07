class Event < ApplicationRecord
    enum status: {
        available: "AVAILABLE",
        in_progress: "IN_PROGRESS",
        booked: "BOOKED",
    }

    validates status, presence: true , inclusion: { in: %w(AVAILABLE IN_PROGRESS BOOKED) }
    validates date, presence: true , comparison: { :greater_than_or_equal_to => Date.today }


end
