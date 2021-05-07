class AddPlanAndStripeChargeErrorToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :plan_id, :string
    add_column :users, :plan_name, :string
    add_column :users, :subscription_id, :string
    add_column :users, :stripe_charge_error, :string
  end
end
