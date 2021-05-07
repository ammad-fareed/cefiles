class ChangeDirectiveEndDateType < ActiveRecord::Migration[6.0]
  def up
    # Rails doesnt like changing a string to a timestamp with change_column
    remove_column :directives, :end_date
    add_column :directives, :end_date, :date
  end

  def down
    remove_column :directives, :end_date
    add_column :directives, :end_date, :string
  end
end
