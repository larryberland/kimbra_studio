class AddGmaps4RailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latitude,  :float #you can change the name, see wiki
    add_column :users, :longitude, :float #you can change the name, see wiki
    add_column :users, :gmaps, :boolean #not mandatory, see wiki
    add_column :users, :formatted_address, :string
    add_column :users, :joined_on, :date
    add_column :users, :csv_row, :integer
  end
end
