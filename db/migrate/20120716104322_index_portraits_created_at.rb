class IndexPortraitsCreatedAt < ActiveRecord::Migration

  def change
    add_index :my_studio_portraits, :created_at
  end

end