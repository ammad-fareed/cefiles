class AddProductLimitToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :published_product_limit, :integer, default: 10
  end
end
