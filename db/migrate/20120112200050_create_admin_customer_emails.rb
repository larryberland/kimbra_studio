class CreateAdminCustomerEmails < ActiveRecord::Migration
  def change
    create_table :admin_customer_emails do |t|
      t.text :message
      t.datetime :sent_at
      t.boolean :active, :default => true
      t.references :my_studio_session

      t.timestamps
    end
    add_index :admin_customer_emails, :my_studio_session_id
  end
end
