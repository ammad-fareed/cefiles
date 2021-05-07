class AddSearchableToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :searchable, :boolean
  end
end
