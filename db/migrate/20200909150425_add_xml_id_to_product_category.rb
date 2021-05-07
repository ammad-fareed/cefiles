class AddXmlIdToProductCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :product_categories,:xml_id,:integer
  end
end
