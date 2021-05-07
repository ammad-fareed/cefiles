class AddArchivedToDirectives < ActiveRecord::Migration[6.0]
  def change
    add_column :directives, :archived, :boolean, null: false, default: false
    add_index :directives, :archived
  end
end
