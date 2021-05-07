class CreateProductDeclarations < ActiveRecord::Migration[6.0]
  def change
    create_table :product_declarations do |t|
      t.string :text
      t.string :file
      t.date :expires_at
      t.references :product
      t.timestamps
    end
  end
end
