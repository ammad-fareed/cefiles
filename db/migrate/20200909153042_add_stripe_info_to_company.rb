class AddStripeInfoToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :plan_name, :string
    add_column :companies, :plan_id, :string
    add_column :companies, :customer_id, :string
    add_column :companies, :subscription_id, :string
    add_column :companies, :stripe_charge_error, :string
    add_column :companies, :current_period_start, :string
    add_column :companies, :current_period_end, :string
    add_column :companies, :deactivated, :string
    add_column :companies, :selected_plan_id,:string
  end
end
