class CreateAdminCustomerItems < ActiveRecord::Migration
  def change
    create_table :admin_customer_items do |t|
      t.references :offer
      t.references :part
      t.boolean :photo, :default => true # this item needs a photo

      t.timestamps
    end
    add_index :admin_customer_items, :offer_id
    add_index :admin_customer_items, :part_id
  end
end
