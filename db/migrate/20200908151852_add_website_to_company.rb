class AddWebsiteToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :website, :string
  end
end
