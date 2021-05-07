class CreateProductDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :product_documents do |t|
      t.string :title
      t.text :description
      t.boolean :public, default: false
      t.string :file
      t.references :product
      t.timestamps
    end
  end
end
