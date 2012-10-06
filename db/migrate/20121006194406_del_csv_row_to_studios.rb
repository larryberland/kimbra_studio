class DelCsvRowToStudios < ActiveRecord::Migration

  def change
    remove_column :studios, :csv_row
  end

end