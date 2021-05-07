class CreateProductsStandards < ActiveRecord::Migration[6.0]
  def change
    create_table :products_standards do |t|
      t.references :product
      t.references :standard
    end
  end
end
