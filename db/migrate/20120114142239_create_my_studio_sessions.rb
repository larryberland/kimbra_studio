class CreateMyStudioSessions < ActiveRecord::Migration
  def change
    create_table :my_studio_sessions do |t|
      t.string :name
      t.datetime :session_at
      t.boolean :active, :default => true
      t.references :studio
      t.references :client
      t.references :category

      t.timestamps
    end
    add_index :my_studio_sessions, :studio_id
    add_index :my_studio_sessions, :client_id
    add_index :my_studio_sessions, :category_id
  end
end
