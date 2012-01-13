class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone_number
      t.timestamps
    end

    create_table :info_studios do |t|
      t.boolean :active, :default => true
      t.string :email_info
      t.string :email
      t.string :tax_id
      t.string :website
      t.boolean :pictage_member
      t.boolean :mac_user
      t.boolean :windows_user
      t.boolean :ping_email
      t.timestamps
    end

    create_table :mini_site_studios do |t|
      t.string :bgcolor
      t.string :logo
      t.string :font_family
      t.string :font_color
      t.timestamps
    end

  end
end
