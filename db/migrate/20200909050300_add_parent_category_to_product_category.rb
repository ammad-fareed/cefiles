class AddParentCategoryToProductCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :product_categories,:parent_id,:integer
  end
end
