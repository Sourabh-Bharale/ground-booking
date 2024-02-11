class User < ApplicationRecord
    has_secure_password
    belongs_to :access_role
    has_many :events 
    has_many :registrations 
    has_many :payments
    validates :mobile_no ,
                :presence => true,
                :uniqueness => true,
                :numericality => true,
                :length => { :minimum => 10, :maximum => 15 }
    validates :user_name , presence:true
    validates :password, :presence => true,
                       :length => {:within => 6..15}
    validates :access_role_id, presence: true
end
