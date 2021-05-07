class AddFileSizeToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :file_size, :integer
  end
end
