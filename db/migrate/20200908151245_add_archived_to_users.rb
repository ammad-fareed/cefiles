class AddArchivedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :archived, :boolean, null: false, default: false
    add_index :users, :archived
  end
end
