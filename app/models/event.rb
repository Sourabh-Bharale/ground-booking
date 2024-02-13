class Event < ApplicationRecord
    belongs_to :user 
    has_many :slots 

    validates :event_status, presence: true , inclusion: { in: %w(AVAILABLE IN_PROGRESS BOOKED) }
    validates :date, presence: true , uniqueness: true , comparison: { :greater_than_or_equal_to => Date.today }
    validates :user_id, presence: true


end
