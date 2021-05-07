class AddImportedAndApprovedToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products,:is_imported,:boolean,default:true
    add_column :products,:is_approved,:boolean
  end
end
