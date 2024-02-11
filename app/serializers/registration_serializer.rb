class RegistrationSerializer < ActiveModel::Serializer
    attributes :id , :slot_id , :user_id , :status , :payment_id , :receipt_url 
    belongs_to :user , serializer: UserSerializer
    belongs_to :slot 
    has_one :payment
end