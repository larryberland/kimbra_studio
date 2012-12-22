class CreateAdminCustomerFriends < ActiveRecord::Migration
  def change
    create_table :admin_customer_friends do |t|
      t.string :name
      t.references :email

      t.timestamps
    end
    add_index :admin_customer_friends, :email_id

    add_column :admin_customer_offers, :friend_id, :integer

  end
end
