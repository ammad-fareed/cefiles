class ChangeProductRecordNumber < ActiveRecord::Migration[6.0]
  def up
    remove_column :products, :record_number
  end
  def down
    add_column :products, :record_number, :string
  end
end
