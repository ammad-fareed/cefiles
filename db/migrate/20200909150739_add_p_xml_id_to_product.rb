class AddPXmlIdToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products,:p_xml_id,:integer
    add_index :products,:p_xml_id
  end
end
