class AddApprovedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :approved, :boolean, default: nil
  end
end