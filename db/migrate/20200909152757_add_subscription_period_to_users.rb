class AddSubscriptionPeriodToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_period_start, :string
    add_column :users, :current_period_end, :string
  end
end
