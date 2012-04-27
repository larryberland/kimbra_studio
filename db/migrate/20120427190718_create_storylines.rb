class CreateStorylines < ActiveRecord::Migration
  def up
    create_table :stories, :force => true do |t|
      t.string :session_id      # We'll get these when the session is created.
      t.text :referer           #
      t.string :ip_address      #
      t.string :marketing_code  #
      t.string :browser         #
      t.string :version         #
      t.string :os              #
      t.string :landing         #
      t.string :first_name  # These only appear when the consumer fills in the credit form.
      t.string :last_name  #
      t.string :city       #
      t.string :state      #
      t.timestamps
    end
    add_index :stories, :session_id
    add_index :stories, [:last_name,:first_name]
    add_index :stories, :marketing_code
    add_index :stories, :created_at
    add_index :stories, :ip_address

    create_table :storylines, :force => true do |t|
      t.references :story
      t.string :session_id
      t.string :url           # Controller and action for this request (no query string for security). format: controller/action
      t.string :description   # Text from the application describing what just happened (the result of this request).
      t.integer :seconds      # Only appears when the NEXT storyline is created.
      t.timestamps
    end
    add_index :storylines, :story_id
    add_index :storylines, :session_id
    add_index :storylines, :url
  end

  def down
    drop_table :stories
    drop_table :storylines
  end

end