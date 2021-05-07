class CreateDirectivesProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :directives_products do |t|
      t.references :directive
      t.references :product
    end
  end
end
