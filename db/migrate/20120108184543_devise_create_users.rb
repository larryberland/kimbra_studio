class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.references :studio
      t.string :first_name, :length => 40
      t.string :last_name, :length => 40
      t.date :birth_date

      t.string :friendly_name
      t.string :email
      t.string :phone_number
      t.string :address_1
      t.string :address_2
      t.string :state
      t.string :city
      t.references :state
      t.string :zip_code
      t.references :country
      t.string :customer_cim_id ## This is the ID returned from AUTH.NET
      t.string :password_salt
      t.string :crypted_password
      t.string :perishable_token
      t.string :persistence_token
      t.string :access_token
      t.integer :comments_count, :default => 0

      t.database_authenticatable :null => false
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable

      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.timestamps
    end

    add_index :users, :studio_id
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :email, :unique => true
    add_index :users, :perishable_token, :unique => true
    add_index :users, :persistence_token, :unique => true
    add_index :users, :access_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

end
