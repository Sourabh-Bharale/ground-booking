class UserSerializer < ActiveModel::Serializer
  attributes :id , :user_name  , :mobile_no , :access_role_id 
  has_many :events
end
