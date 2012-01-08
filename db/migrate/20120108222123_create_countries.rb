class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :abbreviation, :limit => 5
    end
    add_index :countries, :name
  end
end
