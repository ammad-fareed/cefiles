class CreateDirectives < ActiveRecord::Migration[6.0]
  def change
    create_table :directives do |t|
      t.string :code
      t.string :url
      t.date :start_date
      t.string :end_date
      t.references :ce_category
      t.timestamps
    end
    
  end
end
