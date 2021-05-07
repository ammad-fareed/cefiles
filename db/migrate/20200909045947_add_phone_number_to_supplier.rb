class AddPhoneNumberToSupplier < ActiveRecord::Migration[6.0]
  def change
    add_column :suppliers , :phone, :string
    add_column :suppliers , :email, :string
  end
end
