class AddCsvRowToStudios < ActiveRecord::Migration

  def change
    add_column :studios, :csv_row, :integer
  end

end