class AddCompletionToSessions < ActiveRecord::Migration

  def change
    add_column :my_studio_sessions, :finished_uploading_at, :datetime
  end

end
