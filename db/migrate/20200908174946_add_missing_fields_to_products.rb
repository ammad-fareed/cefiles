class AddMissingFieldsToProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :ce_categories_products do |t|
      t.references :ce_category
      t.references :product
    end

    change_table :products do |t|
      t.string :record_number
      t.string :image
      t.boolean :private
      t.references :supplier
      t.references :manufacturer
      t.references :product_category
      t.references :eu_representative
    end

  end
end
