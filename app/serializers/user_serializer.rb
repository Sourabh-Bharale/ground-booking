class UserSerializer < ActiveModel::Serializer
  belongs_to :access_role
  attributes :id , :user_name  , :mobile_no , :access_role_id
  has_many :events
end
