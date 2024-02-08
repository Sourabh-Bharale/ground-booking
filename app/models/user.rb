class User < ApplicationRecord
    has_secure_password
    validates :mobile_no ,
                :presence => true,
                :uniqueness => true,
                :numericality => true,
                :length => { :minimum => 10, :maximum => 15 }
    validates :user_name , presence:true
    validates :password, :presence => true,
                       :length => {:within => 6..15}
end
