class AddApprovedToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :approved, :boolean, default: nil

    add_index :companies, :approved
    add_index :users, :approved
  end
end
