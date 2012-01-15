class CreateMyStudioInfos < ActiveRecord::Migration
  def change
    create_table :my_studio_infos do |t|
      t.references :studio
      t.boolean :active, :default => true
      t.string :website
      t.string :email
      t.string :email_notification
      t.string :tax_ein
      t.boolean :pictage_member
      t.boolean :smug_mug_member
      t.boolean :mac_user
      t.boolean :windows_user
      t.boolean :ping_email, :default => true

      t.timestamps
    end
    add_index :my_studio_infos, :studio_id
  end
end
