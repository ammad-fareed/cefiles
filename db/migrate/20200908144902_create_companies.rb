class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :entity_name
      t.timestamps
    end
    add_index :companies, :name
  end
end
