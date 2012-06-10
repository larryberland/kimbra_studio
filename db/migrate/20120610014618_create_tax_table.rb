class CreateTaxTable < ActiveRecord::Migration

  def change
    create_table :zip_code_taxes, :force => true do |t|
      t.string :state
      t.string :zipcode
      t.string :tax_region_name
      t.string :tax_region_code
      t.decimal :combined_rate, :precision => 7, :scale => 6
      t.decimal :state_rate, :precision => 7, :scale => 6
      t.decimal :county_rate, :precision => 7, :scale => 6
      t.decimal :city_rate, :precision => 7, :scale => 6
      t.decimal :special_rate, :precision => 7, :scale => 6
    end

    add_index :zip_code_taxes, :zipcode

  end

end