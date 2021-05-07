class AddUrlToStandards < ActiveRecord::Migration[6.0]
  def change
    add_column :standards, :url, :string
  end
end
