class Industry < ApplicationRecord
  validates_presence_of :name
  has_many :companies
  def to_s
    name
  end
end
