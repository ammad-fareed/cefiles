class ChangeCompaniesIndustryToReference < ActiveRecord::Migration[6.0]
  def change
    remove_column :companies, :industry
    add_column :companies, :industry_id, :integer

    add_index :companies, :industry_id
  end
end
