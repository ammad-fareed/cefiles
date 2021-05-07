class AddSubscriptionStatusToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :subscription_status, :string
  end
end
