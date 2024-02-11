class Payment < ApplicationRecord
    belongs_to :user
    belongs_to :registration , dependent: :destroy
    # belongs_to :event
    validates :amount, presence: true , numericality: { greater_than: 0 }
    validates :user_id, presence: true
    validates :status, presence: true , inclusion: { in: %w(PENDING PAID FAILED) }
end
 