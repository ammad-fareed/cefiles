class AddAddressIdToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :address_id, :integer
    add_index :companies, :address_id
  end
end
