class AddPXmlImageToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products,:p_xml_image,:string
  end
end
