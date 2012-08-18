class ChangeSessionAtToDate < ActiveRecord::Migration

  def change
    change_column :my_studio_sessions, :session_at,  :date
  end

end