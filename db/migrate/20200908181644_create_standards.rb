class CreateStandards < ActiveRecord::Migration[6.0]
  def change
    create_table :standards do |t|
      t.string :code
      t.string :name
      t.string :organisation
      t.date :expiry_date
      t.timestamps
    end
    create_table :ce_categories_standards do |t|
      t.references :ce_category
      t.references :standard
    end
  end
end
