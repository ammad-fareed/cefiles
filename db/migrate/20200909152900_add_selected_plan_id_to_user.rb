class AddSelectedPlanIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users,:selected_plan_id, :string
  end
end
