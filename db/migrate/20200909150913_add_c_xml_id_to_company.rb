class AddCXmlIdToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies,:c_xml_id ,:integer
    add_index :companies,:c_xml_id
  end
end
