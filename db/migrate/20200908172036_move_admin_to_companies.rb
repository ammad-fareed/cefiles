class MoveAdminToCompanies < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :admin
    add_column :companies, :admin, :boolean, default: false, null: false
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
