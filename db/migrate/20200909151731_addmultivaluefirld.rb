class Addmultivaluefirld < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :eu_countries, :text, array:true, default: []
  end
end
