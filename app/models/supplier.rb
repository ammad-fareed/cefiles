class Supplier < ApplicationRecord
  # VALID_EMAIL_REGEX = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  belongs_to :address
  # validates :email, format: { with: VALID_EMAIL_REGEX }, :if => Proc.new {|s| !s.email.blank?}
  validates :name, presence: true

  accepts_nested_attributes_for :address
  has_many :product_suppliers
end
