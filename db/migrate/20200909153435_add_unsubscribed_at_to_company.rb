class AddUnsubscribedAtToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :unsubscribed_at, :string
  end
end
