class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, :limit => 30, :null => false,   :unique => true
    end
    add_index :roles, :name
  end
end
