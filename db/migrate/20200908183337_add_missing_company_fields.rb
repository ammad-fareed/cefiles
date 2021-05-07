class AddMissingCompanyFields < ActiveRecord::Migration[6.0]
  change_table :companies do |t|
    t.string :industry
    t.string :email
    t.string :phone_number
  end
  remove_column :companies, :entity_name
end
