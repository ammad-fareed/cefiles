class AddArchivedToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :archived, :boolean, default: false, null: false
    add_index :companies, :archived
  end
end
