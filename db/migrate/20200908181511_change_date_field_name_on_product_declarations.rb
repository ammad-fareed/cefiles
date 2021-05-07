class ChangeDateFieldNameOnProductDeclarations < ActiveRecord::Migration[6.0]
  def change
    rename_column :product_declarations, :expires_at, :expiry_date
  end
end
