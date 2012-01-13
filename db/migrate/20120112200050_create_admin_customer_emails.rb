class CreateAdminCustomerEmails < ActiveRecord::Migration
  def change
    create_table :admin_customer_emails do |t|
      t.text :message
      t.datetime :sent_at
      t.boolean :active, :default => true
      t.references :shoot

      t.timestamps
    end
    add_index :admin_customer_emails, :shoot_id
  end
end
