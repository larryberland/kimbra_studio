class CreateStudios < ActiveRecord::Migration
  def change
    create_table :studios do |t|
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.references :state
      t.string :zip_code
      t.references :country
      t.string :phone_number
      t.timestamps
    end
  end
end
