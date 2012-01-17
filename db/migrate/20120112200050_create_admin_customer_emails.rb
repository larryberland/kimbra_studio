class CreateAdminCustomerEmails < ActiveRecord::Migration
  def change
    create_table :admin_customer_emails do |t|
      t.references :my_studio_session
      t.boolean :active, :default => true
      t.text :message
      t.string :activation_code # time_limit activation code for offer
      t.datetime :generated_at # click_plus created email with offers
      t.datetime :sent_at      # click_plus sent email out
      t.datetime :opened_at    # gmail confirmation of opened
      t.datetime :visited_at   # customer visited mini-site from email

      t.timestamps
    end
    add_index :admin_customer_emails, :my_studio_session_id
  end
end
