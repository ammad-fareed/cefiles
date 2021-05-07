class CreateEuRepresentatives < ActiveRecord::Migration[6.0]
  def change
    create_table :eu_representatives do |t|
      t.string :name
      t.references :address
      t.timestamps
    end
  end
end
