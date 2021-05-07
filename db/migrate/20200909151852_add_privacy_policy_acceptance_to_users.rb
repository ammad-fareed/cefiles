class AddPrivacyPolicyAcceptanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :accepted_privacy, :boolean
  end
end
