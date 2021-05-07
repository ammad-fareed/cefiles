class RenameProductDocumentToDocument < ActiveRecord::Migration[6.0]
  def change
    rename_table :product_documents, :documents
  end
end
