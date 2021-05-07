class AddExtraFieldsToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :notified_body_number, :string
    add_column :products, :ce_mark_year,         :string
    add_column :products, :notes,                :text
    add_column :products, :barcode,              :string
  end
end
