class AddArchivedToStandards < ActiveRecord::Migration[6.0]
  def change
    add_column :standards, :archived, :boolean, default: false
    add_index :standards, :archived
  end
end
