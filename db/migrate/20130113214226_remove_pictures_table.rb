class RemovePicturesTable < ActiveRecord::Migration

  def up
    drop_table(:pictures) if ActiveRecord::Base.connection.table_exists? 'pictures'
  end

  def down
  end

end