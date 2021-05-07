class CreateProductSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :product_suppliers do |t|
      t.references :product, index:true
      t.references :supplier,index:true
      t.timestamps
    end
  end
end
