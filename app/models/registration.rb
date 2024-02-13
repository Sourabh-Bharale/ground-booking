class Registration < ApplicationRecord
    belongs_to :slot 
    belongs_to :user 
    has_one :payment , dependent: :destroy
    validates :user_id, presence: true
    validates :status, presence: true , inclusion: { in: %w(PENDING CONFIRMED CANCELED) }
    validates :slot_id, presence: true

end
