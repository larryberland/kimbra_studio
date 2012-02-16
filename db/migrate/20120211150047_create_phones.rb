class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :phone_type
      t.string :number
      t.string :phonable_type
      t.references :phoneable
      t.boolean :primary

      t.timestamps
    end
    add_index :phones, :phone_type_id
    add_index :phones, :phoneable_id
  end
end
