class RemoveStripeFieldsFromUser < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :customer_id
    remove_column :users, :plan_id
    remove_column :users, :plan_name
    remove_column :users, :subscription_id
    remove_column :users, :stripe_charge_error
    remove_column :users, :current_period_start
    remove_column :users, :current_period_end
    remove_column :users, :deactivated
    remove_column :users, :selected_plan_id
  end

  def down
    add_column :users, :plan_name, :string
    add_column :users, :plan_id, :string
    add_column :users, :customer_id, :string
    add_column :users, :subscription_id, :string
    add_column :users, :stripe_charge_error, :string
    add_column :users, :current_period_start, :string
    add_column :users, :current_period_end, :string
    add_column :users, :deactivated, :string
    add_column :users, :selected_plan_id,:string
  end
end
