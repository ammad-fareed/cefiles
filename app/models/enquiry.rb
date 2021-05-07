class Enquiry < ApplicationRecord
  belongs_to :user, optional: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  validates_presence_of :email,  format: { with: VALID_EMAIL_REGEX }
  validates_presence_of :content, :name

end
