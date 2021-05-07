class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.references :company
      t.string :model_number
      t.string :serial_number
      t.text :description
      t.index :name
      t.timestamps
    end

  end
end
