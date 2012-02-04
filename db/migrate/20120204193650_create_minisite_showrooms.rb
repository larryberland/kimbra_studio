class CreateMinisiteShowrooms < ActiveRecord::Migration
  def change
    create_table :minisite_showrooms do |t|
      t.references :offer
      t.references :customer
      t.references :studio

      t.timestamps
    end
    add_index :minisite_showrooms, :offer_id
    add_index :minisite_showrooms, :customer_id
    add_index :minisite_showrooms, :studio_id
  end
end
