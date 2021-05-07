class AddShouldReceiveInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :should_receive_ce_updates, :boolean,default: false
  end
end
