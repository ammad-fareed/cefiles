class AddIndexesToModels < ActiveRecord::Migration[6.0]
  def change
    add_index :ce_categories, :name

    add_index :companies, :entity_name

    add_index :directives, :code

    add_index :standards, :code
    add_index :standards, :name
    add_index :standards, :organisation

    add_index :users, :given_name
    add_index :users, :family_name
  end
end
