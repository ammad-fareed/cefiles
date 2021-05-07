class AddPlanUpdateDateToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :plan_updated_to, :string
    add_column :companies, :plan_updated_from, :string
    add_column :companies, :plan_update_date, :string
  end
end
