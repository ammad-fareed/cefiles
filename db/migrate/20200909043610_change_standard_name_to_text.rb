class ChangeStandardNameToText < ActiveRecord::Migration[6.0]
  def up
    change_column :standards, :name, :text
  end

  def down
    change_column :standards, :name, :string
  end
end
