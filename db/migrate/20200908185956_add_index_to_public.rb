class AddIndexToPublic < ActiveRecord::Migration[6.0]
  def change
    add_index :product_documents, :public
  end
end
