class CreateEnquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :enquiries do |t|
      t.string :name
      t.string :email
      t.references :user
      t.text :content

      t.timestamps
    end
  end
end
