class EventSerializer < ActiveModel::Serializer
    attributes :id , :event_status , :date 
    has_many :slots
    belongs_to :user , serializer: UserSerializer
end
