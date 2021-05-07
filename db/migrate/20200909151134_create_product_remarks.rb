class CreateProductRemarks < ActiveRecord::Migration[6.0]
  def change
    create_table :product_remarks do |t|
      t.text :comments
      t.references :product
      t.timestamps
    end
  end
end
