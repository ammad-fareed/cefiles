class Address < ApplicationRecord
  belongs_to :country

  validates  :country_id, presence: true

  def to_s
    [address_line_1, address_line_2, city, state, postal_code, country].select{ |v| v.present? }.join ', '
  end
end
