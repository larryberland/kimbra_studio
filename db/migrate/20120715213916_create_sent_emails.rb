class CreateSentEmails < ActiveRecord::Migration

  # Sent_emails are a one-stop place to record which emails were sent to whom.
  # Yes, we could interrogate lots of other tables to calculate this, but now it's in one place.
  # This means we have an easy way to verify that we are not spamming consumers with too much email too often.
  def change
    create_table :sent_emails, force:true do |t|
      t.integer :client_id
      t.string :email
      t.string :mailer_name
      t.timestamps
    end

    add_index :sent_emails, :client_id
    add_index :sent_emails, :email

  end

end