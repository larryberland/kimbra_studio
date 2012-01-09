class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.boolean :database_authenticatable, :null => true # TODO:JJ why does this need to be true?
      t.boolean :recoverable
      t.boolean :rememberable
      t.boolean :trackable
      t.string :reset_password_token
      t.string :encrypted_password

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
  end

  def self.down
    remove_index(:users, :column => :reset_password_token)
    remove_column :users, :database_authenticatable
    remove_column :users, :recoverable
    remove_column :users, :rememberable
    remove_column :users, :trackable
    remove_column :users, :reset_password_token
    remove_column :users, :encrypted_password
  end
end
