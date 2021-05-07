class RenamePrivateOnProducts < ActiveRecord::Migration[6.0]
  def up
    rename_column :products, :private, :published
    change_column :products, :published, :boolean, default: false
  end

  def down
    rename_column :products, :published, :private
    change_column :products, :published, :boolean, default: nil
  end
end
