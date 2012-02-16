class CreatePaymentProfiles < ActiveRecord::Migration
  def change
    create_table :payment_profiles do |t|
      t.references :user
      t.references :address
      t.string :payment_cim_id
      t.boolean :default
      t.boolean :active
      t.string :last_digits
      t.string :month
      t.string :year
      t.string :cc_type
      t.string :first_name
      t.string :last_name
      t.string :card_name

      t.timestamps
    end
    add_index :payment_profiles, :user_id
    add_index :payment_profiles, :address_id
  end
end
