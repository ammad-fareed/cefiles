class AddShareCodeToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :share_code, :string
  end
end
