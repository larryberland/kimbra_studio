class CreateStudioEmailsTable < ActiveRecord::Migration

  def up
    create_table :studio_emails do |t|
      t.integer :studio_id
      t.string :email_name
      t.datetime :sent_at
      t.datetime :clicked_through_at
    end

    add_index :studio_emails, :studio_id, unique: false
    add_index :studio_emails, :email_name, unique: false
    add_index :studio_emails, :sent_at, unique: false
    add_index :studio_emails, :clicked_through_at, unique: false


  end

  def down
    drop_table :studio_emails
  end

end